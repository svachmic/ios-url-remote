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

/// View Model for controller enabling editing/deleting/rearranging of entries.
class SettingsViewModel {
    /// Dispose bag for observables/signals in the scope of the viewModel.
    let bndBag = DisposeBag()
    /// Entries to be edited.
    let entries = MutableObservableArray<Entry>([])
    /// Category name
    let categoryName = Observable<String>("")
    
    /// Signal emitting Entries to be modified.
    let signal = PublishSubject<Entry, NoError>()
    /// Signal emitting Entries to be deleted.
    let deleteSignal = PublishSubject<Entry, NoError>()
    
    init() {
        NotificationCenter.default.reactive.notification(name: NSNotification.Name(rawValue: "CREATED_ENTRY"))
            .observeNext { notification in
                let entry = notification.object as! Entry
                self.replace(with: entry)
            }.dispose(in: self.bndBag)
    }
    
    /// Sets up/populates observable entries array.
    ///
    /// - Parameter entries: Array of entries to be displayed.
    func setupEntries(entries: [Entry]) {
        self.entries.removeAll()
        self.entries.insert(contentsOf: entries, at: 0)
    }
    
    /// Replaces the entry in the observable array with the entry given on the input.
    /// This method is used when an entry is modified to reflect the changes in the observable array for next edits.
    /// It finds the existing entry by its ID and replaces it.
    ///
    /// - Parameter entry: Entry to be put into the array.
    private func replace(with entry: Entry) {
        var entryIndex = -1
        for index in 0..<self.entries.count {
            let e = self.entries[index]
            if let firOrigin = e.firebaseKey, let firDest = entry.firebaseKey, firOrigin == firDest {
                entryIndex = index
            }
        }
        
        if entryIndex != -1 {
            self.entries.remove(at: entryIndex)
            self.entries.insert(entry, at: entryIndex)
        }
    }
    
    /// Moves entries up/down. This method is called when an entry has been drag & dropped in the table view.
    ///
    /// - Parameter from: Index where the d&d started.
    /// - Parameter to: Index where the d&d ended.
    func moveItem(from: Int, to: Int) {
        self.entries.moveItem(from: from, to: to)
        
        for index in 0..<self.entries.count {
            let entry = self.entries[index]
            entry.order = index
            self.signal.next(entry)
        }
    }
    
    /// Removes item fully from the database.
    ///
    /// - Parameter index: Index of the entry to be deleted.
    func removeItem(index: Int) {
        let entry = self.entries[index]
        self.entries.remove(at: index)
        self.deleteSignal.next(entry)
        
        for index in 0..<self.entries.count {
            let entry = self.entries[index]
            entry.order = index
            self.signal.next(entry)
        }
    }
}
