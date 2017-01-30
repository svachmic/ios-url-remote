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
    private var entriesRef: FIRDatabaseReference {
        return userDataRef.child("entries")
    }
    
    /// Returns a signal with Firebase events.
    ///
    /// - Returns: Signal with an array of entries giving no error.
    func entriesSignal() -> Signal<[Entry], NoError> {
        return entriesRef.signalForEvent(event: .value)
            .map { snapshot in
                return Mapper<Entry>().mapArray(
                    JSONArray: snapshot.children
                        .map { $0 as! FIRDataSnapshot }
                        .map { $0.value as! [String : AnyObject] }
                    )?.sorted { $0.0.order < $0.1.order } ?? []
        }.flatMapError { _ in Signal<[Entry], NoError>.sequence([])}
    }
    
    // MARK: - Write
    
    /// Performs writing operation. If an entry with the saem Firebase Key does not exist a new one is created. Otherwise the old one is updated.
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
