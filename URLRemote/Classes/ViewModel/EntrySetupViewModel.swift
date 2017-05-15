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

/// Struct representing a cell in the Entry Setup View Controller.
struct EntrySetupTableCell {
    
    /// The Storyboard identifier by which the cell is initialized.
    let identifier: String
    
    /// The height of the cell.
    let height: CGFloat
}

/// View Model of the Entry Setup View Controller. Handles UI state + form validity.
class EntrySetupViewModel {
    let bndBag = DisposeBag()
    
    var firebaseKey: String?
    let order = Observable<Int>(0)
    let name = Observable<String>("")
    let color = Observable<ColorName>(.yellow)
    let icon = Observable<String>("plus")
    let url = Observable<String>("")
    let type = Observable<EntryType>(.simpleHTTP)
    let requiresAuthentication = Observable<Bool>(false)
    let user = Observable<String?>(nil)
    let password = Observable<String?>(nil)
    let customCriteria = Observable<String>("")
    
    /// Observable property indicating the completeness of the form.
    let isFormComplete = Observable<Bool>(false)
    
    /// Contents of the form.
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
    
    /// Initializes all necessary bindings:
    /// 1. Validation of data.
    /// 2. Addition/Removal of custom criteria cell into the table view model.
    /// 3. Notification handling for selection of icon.
    init() {
        self.bindValidation()
        
        _ = self.type.observeNext { type in
            if type == .custom {
                if self.contents.count == 3 {
                    let cell = EntrySetupTableCell(
                        identifier: "criteriaCell",
                        height: 94.0)
                    self.contents.insert(cell, at: 2)
                }
            } else {
                if self.contents.count == 4 {
                    self.contents.remove(at: 2)
                    self.customCriteria.value = ""
                }
            }
        }
        
        NotificationCenter.default.reactive.notification(name: NSNotification.Name(rawValue: "SELECTED_ICON"))
            .map { return $0.object as! String }
            .bind(to: self.icon)
            .dispose(in: self.bndBag)
    }
    
    /// Binds form validation to isFormComplete observable property.
    func bindValidation() {
        combineLatest(
            self.name,
            self.url,
            self.requiresAuthentication,
            self.user,
            self.password)
            .map { name, url, auth, usr, pwd in
                if name == "" || url == "" || !url.isValidURL() {
                    return false
                }
                
                if auth {
                    let areCredentialsNil = (usr == nil || pwd == nil)
                    let areCredentialsBlank = (usr == "" || pwd == "")
                    
                    /// The return must be exclusive and return a value if and only if the undesired state ocurrs.
                    if areCredentialsNil || areCredentialsBlank {
                        return false
                    }
                }
                
                return true
            }.bind(to: self.isFormComplete)
            .dispose(in: self.bndBag)
    }
    
    /// Sets observed form data to have previously generated Entry data.
    ///
    /// - Parameter entry: Previously created Entry object with data.
    func setup(with entry: Entry) {
        self.firebaseKey = entry.firebaseKey
        self.order.value = entry.order
        self.name.value = entry.name ?? ""
        self.color.value = entry.color ?? .yellow
        self.icon.value = entry.icon ?? "plus"
        self.url.value = entry.url ?? ""
        self.type.value = entry.type ?? .simpleHTTP
        self.requiresAuthentication.value = entry.requiresAuthentication
        self.user.value = entry.user
        self.password.value = entry.password
        self.customCriteria.value = entry.customCriteria ?? ""
    }
    
    /// Transforms the form data into an Entry object.
    ///
    /// - Returns: Model Entry object filled with user-generated data.
    func toEntry() -> Entry {
        let entry = Entry()
        entry.firebaseKey = self.firebaseKey
        entry.order = self.order.value
        entry.name = self.name.value
        entry.color = self.color.value
        entry.icon = self.icon.value
        entry.url = self.url.value
        
        if let l = self.user.value, let p = self.password.value, self.requiresAuthentication.value {
            entry.requiresAuthentication = true
            entry.user = l
            entry.password = p
        }
        
        entry.type = self.type.value
        if self.type.value == .custom {
            entry.customCriteria = self.customCriteria.value
        }
        
        return entry
    }
}
