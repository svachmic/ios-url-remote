//
//  FireBaseDataStore.swift
//  URLRemote
//
//  Created by Michal Švácha on 15/12/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond
import FirebaseAuth
import FirebaseDatabase
import ObjectMapper

/// Firebase + ObjectMapper extension
extension DataSnapshot {
    
    /// Parses Firebase Data Snapshot into an array of model objects.
    ///
    /// - Returns: Object array of type that is a subclass of FirebaseObject.
    func toArray<T: FirebaseObject>() -> [T] {
        return Mapper<T>().mapArray(
            JSONArray: self.children
                .map { $0 as! DataSnapshot }
                .map { $0.value as! [String : AnyObject] }
            ).sorted()
    }
}

///
class FirebaseDataSourceAuthentication: DataSourceAuthentication {
    
    func dataSourceSignal() -> Signal<DataSource?, NoError> {
        return Signal { observer in
            let listener = { (auth: Auth, user: User?) -> Void in
                if let u = user {
                    observer.next(FirebaseDataSource(user: u))
                } else {
                    observer.next(nil)
                }
            }
            let handle = Auth.auth().addStateDidChangeListener(listener)
            
            return BlockDisposable {
                Auth.auth().removeStateDidChangeListener(handle)
            }
        }
    }
    
    private func handleSignedUser(user: User?, error: Error?, observer: AtomicObserver<DataSource, AuthError>) {
        if let user = user {
            let dataSource = FirebaseDataSource(user: user)
            observer.next(dataSource)
            observer.completed()
        } else {
            observer.failed(AuthError.error(error: error))
            observer.completed()
        }
    }
    
    func createUser(email: String, password: String) -> Signal<DataSource, AuthError> {
        return Signal { observer in
            Auth.auth().createUser(withEmail: email, password: password) { [unowned self] user, error in
                self.handleSignedUser(user: user, error: error, observer: observer)
            }
            
            return NonDisposable.instance
        }
    }
    
    func signIn(email: String, password: String) -> Signal<DataSource, AuthError> {
        return Signal { observer in
            Auth.auth().signIn(withEmail: email, password: password) { [unowned self] user, error in
                self.handleSignedUser(user: user, error: error, observer: observer)
            }
            
            return NonDisposable.instance
        }
    }
    
    func logOut() {
        try? Auth.auth().signOut()
    }
}

/// Firebase ReactiveKit wrapper to enable reactive bindings.
class FirebaseDataSource: DataSource {
    var user: User
    var database: Database
    let isOnline = Observable<Bool>(false)
    
    init(user: User) {
        self.user = user
        self.database = Database.database()
        _ = self.isOnline.bind(signal: connectionSignal())
    }
    
    // MARK: - Connection status
    
    /// Computed value indicating connection status.
    private var connectedRef: DatabaseReference {
        return database.reference(withPath: ".info/connected")
    }
    
    /// Turns computed value into a signal to indicate connection status.
    ///
    /// - Returns: Signal with Bool value giving no error.
    private func connectionSignal() -> Signal<Bool, NoError> {
        return connectedRef.signalForEvent(event: .value)
            .map { $0.value as! Bool }
            .flatMapError { _ in Signal<Bool, NoError>.sequence([])}
    }
    
    // MARK: - Data
    
    /// Computed variable with all user data.
    private var userDataRef: DatabaseReference {
        return database.reference().child("users/\(user.uid)")
    }
    
    /// Computed variable with all entries of the user.
    private var categoriesRef: DatabaseReference {
        return userDataRef.child("categories")
    }
    
    /// Returns a signal with Firebase events.
    ///
    /// - Returns: Signal with an array of entries giving no error.
    func categoriesSignal() -> Signal<[Category], NoError> {
        return categoriesRef.signalForEvent(event: .value)
            .map { snapshot in
                return snapshot.toArray()
            }.flatMapError { _ in Signal<[Category], NoError>.sequence([])}
    }
    
    /// Computed variable with all entries of the user.
    private var entriesRef: DatabaseReference {
        return userDataRef.child("entries")
    }
    
    /// Returns a signal with Firebase events.
    ///
    /// - Returns: Signal with an array of entries giving no error.
    func entriesSignal() -> Signal<[Entry], NoError> {
        return entriesRef.signalForEvent(event: .value)
            .map { snapshot in
                return snapshot.toArray()
        }.flatMapError { _ in Signal<[Entry], NoError>.sequence([])}
    }
    
    // MARK: - Write
    
    ///
    private func writeWithExistenceAssertion(_ category: Category) -> String {
        var reference: DatabaseReference
        
        if let key = category.firebaseKey {
            reference = categoriesRef.child(key)
        } else {
            reference = categoriesRef.childByAutoId()
            category.firebaseKey = reference.key
        }
        
        reference.setValue(category.toJSON())
        return reference.key
    }
    
    /// Performs writing operation. If a category with the same Firebase Key does not exist a new one is created. Otherwise the old one is updated.
    ///
    /// - Parameter category: Category to be written in the database.
    func write(_ category: Category) {
        _ = self.writeWithExistenceAssertion(category)
    }
    
    /// Deletes category from the database.
    ///
    /// - Parameter category: Category to be deleted.
    func delete(_ category: Category) {
        if let key = category.firebaseKey {
            let reference = categoriesRef.child(key)
            reference.removeValue()
        }
    }
    
    ///
    func move(entry: Entry, from: Category, to: Category, shuffleOrder: Bool = false) {
        if let key = entry.firebaseKey, let index = from.entryKeys.index(where: { $0 == key }) {
            from.entryKeys.remove(at: index)
            self.write(from)
        }
        
        // other entries' order is reshuffled after the write has been finished
        // SettingsViewModel line 35
        // TODO: Solve this with a better pattern - prepared parameter shuffleOrder
        entry.order = to.entryKeys.count
        
        let entryKey = self.writeWithExistenceAssertion(entry)
        to.entryKeys.append(entryKey)
        self.write(to)
    }
    
    ///
    private func writeWithExistenceAssertion(_ entry: Entry) -> String {
        var reference: DatabaseReference
        
        if let key = entry.firebaseKey {
            reference = entriesRef.child(key)
        } else {
            reference = entriesRef.childByAutoId()
            entry.firebaseKey = reference.key
        }
        
        reference.setValue(entry.toJSON())
        return reference.key
    }
    
    /// Performs writing operation. If an entry with the same Firebase Key does not exist a new one is created. Otherwise the old one is updated.
    ///
    /// - Warning: Subject to change with full Category implementation.
    ///
    /// - Parameter entry: Entry to be written in the database.
    func write(_ entry: Entry) {
        _ = self.writeWithExistenceAssertion(entry)
    }
    
    ///
    func write(entry: Entry, category: Category) {
        let entryKey = self.writeWithExistenceAssertion(entry)
        
        if !category.entryKeys.contains(entryKey) {
            category.entryKeys.append(entryKey)
        }
        
        self.write(category)
    }
    
    /// Deletes entry from the database.
    ///
    /// - Parameter entry: Entry to be deleted.
    func delete(_ entry: Entry) {
        if let key = entry.firebaseKey {
            let reference = entriesRef.child(key)
            reference.removeValue()
        }
    }
}
