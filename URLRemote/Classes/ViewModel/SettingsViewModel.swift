//
//  EditViewModel.swift
//  URLRemote
//
//  Created by Michal Švácha on 18/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond

///
class SettingsViewModel {
    ///
    let bndBag = DisposeBag()
    ///
    let entries = MutableObservableArray<Entry>([])
    ///
    let signal = PublishSubject<Entry, NoError>()
    
    init() {
        NotificationCenter.default.bnd_notification(name: NSNotification.Name(rawValue: "CREATED_ENTRY"))
            .observeNext { notification in
                let entry = notification.object as! Entry
                self.replace(with: entry)
            }.dispose(in: self.bndBag)
    }
    
    
    ///
    ///
    /// - Parameter entries:
    func setupEntries(entries: [Entry]) {
        self.entries.removeAll()
        self.entries.insert(contentsOf: entries, at: 0)
    }
    
    ///
    ///
    /// - Parameter entry:
    func replace(with entry: Entry) {
        var entryIndex = -1
        for index in 0..<self.entries.count {
            let e = self.entries[index]
            if let fir_origin = e.firebaseKey, let fir_dest = entry.firebaseKey, fir_origin == fir_dest {
                entryIndex = index
            }
        }
        
        if entryIndex != -1 {
            self.entries.remove(at: entryIndex)
            self.entries.insert(entry, at: entryIndex)
        }
    }
    
    ///
    ///
    /// - Parameter from:
    /// - Parameter to:
    func moveItem(from: Int, to: Int) {
        self.entries.moveItem(from: from, to: to)
        
        for index in 0..<self.entries.count {
            let entry = self.entries[index]
            entry.order = index
            self.signal.next(entry)
        }
    }
}
