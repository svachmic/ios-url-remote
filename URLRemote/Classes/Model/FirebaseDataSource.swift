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

///
class FirebaseDataSource {
    var user: FIRUser
    var database: FIRDatabase
    var isOnline = Observable<Bool>(false)
    
    init(user: FIRUser, database: FIRDatabase) {
        self.user = user
        self.database = database
        _ = self.isOnline.bind(signal: connectionSignal())
    }
    
    // MARK: - Connection status
    
    ///
    private var connectedRef: FIRDatabaseReference {
        return database.reference(withPath: ".info/connected")
    }
    
    ///
    private func connectionSignal() -> Signal<Bool, NoError> {
        return connectedRef.signalForEvent(event: .value)
            .map { $0.value as! Bool }
            .flatMapError { _ in Signal<Bool, NoError>.sequence([])}
    }
    
    // MARK: - Data
    
    ///
    private var userDataRef: FIRDatabaseReference {
        return database.reference().child("users/\(user.uid)")
    }
    
    ///
    private var entriesRef: FIRDatabaseReference {
        return userDataRef.child("entries")
    }
    
    ///
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
    
    ///
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
    
    ///
    func delete(_ entry: Entry) {
        if let key = entry.firebaseKey {
            let reference = entriesRef.child(key)
            reference.removeValue()
        }
    }
}
