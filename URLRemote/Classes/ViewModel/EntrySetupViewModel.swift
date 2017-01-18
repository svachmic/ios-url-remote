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
    let bndBag = DisposeBag()
    
    private var firebaseKey: String? = nil
    private var order: Int = 0
    let name = Observable<String>("")
    let color = Observable<ColorName>(.yellow)
    let icon = Observable<String>("plus")
    let url = Observable<String>("")
    let type = Observable<EntryType>(.SimpleHTTP)
    let requiresAuthentication = Observable<Bool>(false)
    let user = Observable<String?>(nil)
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
        
        NotificationCenter.default.bnd_notification(name: NSNotification.Name(rawValue: "SELECTED_ICON"))
            .map { return $0.object as! String }
            .bind(to: self.icon)
            .dispose(in: self.bndBag)
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
                
                if auth && (self.user.value == nil || self.password.value == nil) {
                    return false
                }
                
                return true
            }.bind(to: self.isFormComplete)
    }
    
    ///
    func setup(with entry: Entry) {
        self.firebaseKey = entry.firebaseKey
        self.order = entry.order
        self.name.value = entry.name ?? ""
        self.color.value = entry.color ?? .yellow
        self.icon.value = entry.icon ?? "plus"
        self.url.value = entry.url ?? ""
        self.type.value = entry.type ?? .SimpleHTTP
        self.requiresAuthentication.value = entry.requiresAuthentication
        self.user.value = entry.user
        self.password.value = entry.password
    }
    
    ///
    func toEntry() -> Entry {
        let entry = Entry()
        entry.firebaseKey = self.firebaseKey
        entry.order = self.order
        entry.name = self.name.value
        entry.color = self.color.value
        entry.icon = self.icon.value
        entry.url = self.url.value
        entry.type = self.type.value
        if let l = self.user.value, let p = self.password.value, self.requiresAuthentication.value {
            entry.requiresAuthentication = true
            entry.user = l
            entry.password = p
        }
        
        return entry
    }
}
