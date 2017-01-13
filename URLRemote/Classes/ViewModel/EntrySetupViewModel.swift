//
//  EntrySetupViewModel.swift
//  URLRemote
//
//  Created by Michal Švácha on 04/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit

///
struct EntrySetupTableCell {
    let identifier: String
    let height: CGFloat
}

///
class EntrySetupViewModel {
    let name = Observable<String>("")
    let color = Observable<ColorName>(.yellow)
    let icon = Observable<String>("plus")
    let url = Observable<String>("")
    let type = Observable<EntryType>(.SimpleHTTP)
    let requiresAuthentication = Observable<Bool>(false)
    let login = Observable<String?>(nil)
    let password = Observable<String?>(nil)
    
    ///
    let isFormComplete = Observable<Bool>(false)
    
    // Table
    let contents = MutableObservableArray<EntrySetupTableCell>([
        EntrySetupTableCell(
            identifier: "designCell",
            height: 133.0),
        EntrySetupTableCell(
            identifier: "typeCell",
            height: 68.0),
        EntrySetupTableCell(
            identifier: "actionCell",
            height: 228.0)
        ])
    
    ///
    init() {
        self.bindValidation()
    }
    
    ///
    func bindValidation() {
        combineLatest(
            self.name,
            self.url,
            self.requiresAuthentication)
            .map { name, url, auth in
                if name == "" || url == "" {
                    return false
                }
                
                if auth && (self.login.value == nil || self.password.value == nil) {
                    return false
                }
                
                return true
            }.bind(to: self.isFormComplete)
    }
    
    ///
    func toEntry() -> Entry {
        let entry = Entry()
        //entry.name = self.name.value
        entry.color = self.color.value
        entry.icon = self.icon.value
        entry.url = self.url.value
        entry.type = self.type.value
        return entry
    }
}
