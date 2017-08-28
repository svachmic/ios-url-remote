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

/// Firebase Auth implementation of DataSourceAuthentication protocol.
class FirebaseDataSourceAuthentication: DataSourceAuthentication {
    
    /// Wraps FirebaseAuthentication's auth() listener in a Signal and returns it.
    func dataSource() -> Signal<DataSource?, NoError> {
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
    
    /// Handles sign in/up operation by calling appropriate methods on given observer.
    ///
    /// - Parameter user: User object returned after sign in/up action.
    /// - Parameter error: Error provided during sign in/up action.
    /// - Parameter observer: Signal observer observing the operation.
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
    
    /// Wraps the Firebase Authentication's createUser in a Signal and returns it.
    func createUser(email: String, password: String) -> Signal<DataSource, AuthError> {
        return Signal { observer in
            Auth.auth().createUser(withEmail: email, password: password) { [unowned self] user, error in
                self.handleSignedUser(user: user, error: error, observer: observer)
            }
            
            return NonDisposable.instance
        }
    }
    
    /// Wraps the Firebase Authentication's signIn in a Signal and returns it.
    func signIn(email: String, password: String) -> Signal<DataSource, AuthError> {
        return Signal { observer in
            Auth.auth().signIn(withEmail: email, password: password) { [unowned self] user, error in
                self.handleSignedUser(user: user, error: error, observer: observer)
            }
            
            return NonDisposable.instance
        }
    }
    
    /// Logs user out. Fails silently.
    func logOut() {
        try? Auth.auth().signOut()
    }
}

/// Firebase implementation of DataSource protocol.
class FirebaseDataSource: DataSource {
    var user: User
    var database: Database
    let isOnline = Observable<Bool>(false)
    
    /// Initializes the object and sets up the real-time database.
    ///
    /// - Parameter user: Firebase object representing a signed in user.
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
    /// - Returns: Signal with Bool value representing the connection status, giving no error.
    private func connectionSignal() -> Signal<Bool, NoError> {
        return connectedRef.signalForEvent(event: .value)
            .map { $0.value as! Bool }
            .flatMapError { _ in Signal<Bool, NoError>.sequence([])}
    }
    
    // MARK: - Read -
    
    /// Computed variable with all user data.
    private var userDataRef: DatabaseReference {
        return database.reference().child("users/\(user.uid)")
    }
    
    // MARK: Categories
    
    /// Computed variable with all entries of the user.
    private var categoriesRef: DatabaseReference {
        return userDataRef.child("categories")
    }
    
    /// Processes Firebase events into a signal of categories.
    func categories() -> Signal<[Category], NoError> {
        return categoriesRef.signalForEvent(event: .value)
            .map { snapshot in
                return snapshot.toArray()
            }.flatMapError { _ in Signal<[Category], NoError>.sequence([])}
    }
    
    // MARK: Entries
    
    /// Computed variable with all entries of the user.
    private var entriesRef: DatabaseReference {
        return userDataRef.child("entries")
    }
    
    /// Processes Firebase events into a signal of categories.
    func entries() -> Signal<[Entry], NoError> {
        return entriesRef.signalForEvent(event: .value)
            .map { snapshot in
                return snapshot.toArray()
        }.flatMapError { _ in Signal<[Entry], NoError>.sequence([])}
    }
    
    // MARK: - Write -
    
    /// Modifies the given object by assigning it a unique firebaseKey. After assigned, the object is persisted in the given path.
    /// - DISCUSSION: Returned String is no longer used. Subject to removal?
    ///
    /// - Parameter domainReference: Path in the database tree where the object should be stored.
    /// - Parameter object: FirebaseObject to be persisted.
    /// - Returns: String representing the assigned firebaseKey.
    private func writeWithExistenceAssertion(using domainReference: DatabaseReference, object: FirebaseObject) -> String {
        var reference: DatabaseReference
        
        if let key = object.firebaseKey {
            reference = domainReference.child(key)
        } else {
            reference = domainReference.childByAutoId()
            object.firebaseKey = reference.key
        }
        
        reference.setValue(object.toJSON())
        return reference.key
    }
    
    // MARK: Categories
    
    /// First modifies the category by assigning it unique firebaseKey, then persists it.
    func update(_ category: Category) {
        _ = self.writeWithExistenceAssertion(using: categoriesRef, object: category)
    }
    
    /// Deletes category from the database if firebaseKey is not nil. Fails silently.
    func delete(_ category: Category) {
        if let key = category.firebaseKey {
            let reference = categoriesRef.child(key)
            reference.removeValue()
        }
    }
    
    // MARK: Entries
    
    /// First modifies the entry by assigning it unique firebaseKey, then persists it.
    func update(_ entry: Entry) {
        _ = self.writeWithExistenceAssertion(using: entriesRef, object: entry)
    }
    
    /// Deletes entry from the database if firebaseKey is not nil. Fails silently.
    func delete(_ entry: Entry) {
        if let key = entry.firebaseKey {
            let reference = entriesRef.child(key)
            reference.removeValue()
        }
    }
}
