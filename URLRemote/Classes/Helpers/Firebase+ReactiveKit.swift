//
//  FireBase+Bond.swift
//  URLRemote
//
//  Created by Michal Švácha on 15/12/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import Foundation
import FirebaseDatabase
import ReactiveKit

/// ReactiveKit extension to allow turning events into signals.
extension FIRDatabaseReference {
    
    /// Turns Firebase events into a signal of continuous events.
    ///
    /// - Parameter event: Firebase data event type to observe.
    /// - Returns: Signal with continuous events enabling reactive binding.
    func signalForEvent(event: FIRDataEventType) -> Signal<FIRDataSnapshot, NSError> {
        return Signal { observer in
            let handle = self.observe(event, with: { snapshot in
                observer.next(snapshot)
            }, withCancel: { err in
                observer.failed(err as NSError)
            })
            
            return BlockDisposable {
                self.removeObserver(withHandle: handle)
            }
        }
    }
    
    /// Turns Firebase event into a single signal of an event.
    ///
    /// - Parameter event: Firebase data event type to observe.
    /// - Returns: Signal with a single event enabling reactive binding.
    func signalForSingleEvent(event: FIRDataEventType) -> Signal<FIRDataSnapshot, NSError> {
        return Signal { observer in
            self.observeSingleEvent(of: event, with: { snapshot in
                observer.next(snapshot)
                observer.completed()
            })
            
            return NonDisposable.instance
        }
    }
}
