//
//  EditViewModel.swift
//  URLRemote
//
//  Created by Michal Švácha on 18/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import Bond

///
class SettingsViewModel {
    ///
    let entries = MutableObservableArray<Entry>([])
    
    ///
    ///
    /// - Parameter entries:
    func setupEntries(entries: [Entry]) {
        self.entries.removeAll()
        self.entries.insert(contentsOf: entries, at: 0)
    }
}
