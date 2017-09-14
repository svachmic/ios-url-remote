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
    var dataSource: DataSource!
    let bag = DisposeBag()
    
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
    
    let categories = MutableObservableArray<Category>([])
    let originalCategoryIndex = Observable<Int?>(nil)
    let selectedCategoryIndex = Observable<Int>(0)
    
    /// Observable property indicating the completeness of the form.
    let isFormComplete = Observable<Bool>(false)
    
    /// Contents of the form.
    let contents = MutableObservableArray<EntrySetupTableCell>([
        EntrySetupTableCell(
            identifier: "designCell",
            height: 133.0),
        EntrySetupTableCell(
            identifier: "categoryCell",
            height: 68.0),
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
    ///
    /// - Parameter dataSource: DataSource class whoch handles data persistence.
    init(dataSource: DataSource) {
        self.dataSource = dataSource
        
        self.dataSource.categories().observeNext { [unowned self] in
            self.categories.replace(with: $0, performDiff: false)
        }.dispose(in: bag)
        
        self.bindValidation()
        
        originalCategoryIndex.map { $0 ?? 0 }.bind(to: selectedCategoryIndex).dispose(in: bag)
        
        self.type.observeNext { [unowned self] type in
            if type == .custom {
                if self.contents.count == 4 {
                    let cell = EntrySetupTableCell(
                        identifier: "criteriaCell",
                        height: 94.0)
                    self.contents.insert(cell, at: 3)
                }
            } else {
                if self.contents.count == 5 {
                    self.contents.remove(at: 3)
                    self.customCriteria.value = ""
                }
            }
        }.dispose(in: bag)
    }
    
    /// Binds form validation to isFormComplete observable property.
    func bindValidation() {
        let fieldsValidation = combineLatest(name, url).map { (name, url) -> Bool in
            return !(name == "" || url == "" || !url.isValidURL())
        }
        
        let credentialsValidation = combineLatest(requiresAuthentication, user, password).map { (auth, usr, pwd) -> Bool in
            if auth {
                let areCredentialsNil = (usr == nil || pwd == nil)
                let areCredentialsBlank = (usr == "" || pwd == "")
                
                /// The return must be exclusive and return a value if and only if the undesired state ocurrs.
                if areCredentialsNil || areCredentialsBlank {
                    return false
                }
            }
            
            return true
        }
        
        combineLatest(fieldsValidation, credentialsValidation)
            .map { $0 && $1 }
            .bind(to: self.isFormComplete)
            .dispose(in: bag)
    }
    
    /// Sets observed form data to have previously generated Entry data.
    ///
    /// - Parameter entry: Previously created Entry object with data.
    func setup(with entry: Entry) {
        dataSource.categories().map { (cats: [Category]) -> Int? in
            for index in 0..<cats.count {
                if cats[index].contains(entry: entry) {
                    return index
                }
            }
            return nil
        }.bind(to: originalCategoryIndex)
        .dispose(in: bag)
        
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
    
    /// Persists the data. Decides between move/update/save new.
    func saveData() {
        let entry = self.toEntry()
        
        if let originalIdx = originalCategoryIndex.value {
            let fromCategory = categories[originalIdx]
            
            if originalIdx != selectedCategoryIndex.value {
                let toCategory = categories[selectedCategoryIndex.value]
                dataSource.move(entry, from: fromCategory, to: toCategory)
            } else {
                // update
                dataSource.add(entry, to: fromCategory)
            }
        } else {
            // new
            let toCategory = categories[selectedCategoryIndex.value]
            dataSource.add(entry, to: toCategory)
        }
    }
}
