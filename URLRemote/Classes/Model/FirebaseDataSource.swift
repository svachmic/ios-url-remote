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
extension FIRDataSnapshot {
    
    /// Parses Firebase Data Snapshot into an array of model objects.
    ///
    /// - Returns: Object array of type that is a subclass of FirebaseObject.
    func toArray<T: FirebaseObject>() -> [T] {
        return Mapper<T>().mapArray(
            JSONArray: self.children
                .map { $0 as! FIRDataSnapshot }
                .map { $0.value as! [String : AnyObject] }
            )?.sorted() ?? []
    }
}

/// Firebase ReactiveKit wrapper to enable reactive bindings.
class FirebaseDataSource {
    var user: FIRUser
    var database: FIRDatabase
    var isOnline = Observable<Bool>(false)
    
    init(user: FIRUser) {
        self.user = user
        self.database = FIRDatabase.database()
        _ = self.isOnline.bind(signal: connectionSignal())
    }
    
    // MARK: - Connection status
    
    /// Computed value indicating connection status.
    private var connectedRef: FIRDatabaseReference {
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
    private var userDataRef: FIRDatabaseReference {
        return database.reference().child("users/\(user.uid)")
    }
    
    /// Computed variable with all entries of the user.
    private var categoriesRef: FIRDatabaseReference {
        return userDataRef.child("categories")
    }
    
    /// Returns a signal with Firebase events.
    ///
    /// - Returns: Signal with an array of entries giving no error.
    func categoriesSignal() -> Signal<[Category], NoError> {
        return entriesRef.signalForEvent(event: .value)
            .map { snapshot in
                return snapshot.toArray()
            }.flatMapError { _ in Signal<[Category], NoError>.sequence([])}
    }
    
    /// Computed variable with all entries of the user.
    private var entriesRef: FIRDatabaseReference {
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
    
    /// Performs writing operation. If a category with the same Firebase Key does not exist a new one is created. Otherwise the old one is updated.
    ///
    /// - Parameter category: Category to be written in the database.
    func write(_ category: Category) {
        var reference: FIRDatabaseReference?
        
        if let key = category.firebaseKey {
            reference = categoriesRef.child(key)
        } else {
            reference = categoriesRef.childByAutoId()
            category.firebaseKey = reference!.key
        }
        
        reference?.setValue(category.toJSON())
    }
    
    /// Performs writing operation. If an entry with the same Firebase Key does not exist a new one is created. Otherwise the old one is updated.
    ///
    /// - Warning: Subject to change with full Category implementation.
    ///
    /// - Parameter entry: Entry to be written in the database.
    func write(_ entry: Entry) {
        var reference: FIRDatabaseReference?
        
        if let key = entry.firebaseKey {
            reference = entriesRef.child(key)
        } else {
            reference = entriesRef.childByAutoId()
            entry.firebaseKey = reference!.key
        }
        
        reference?.setValue(entry.toJSON())
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
