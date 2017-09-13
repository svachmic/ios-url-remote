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
class CategoryEditViewModel {
    let dataSource: DataSource
    let bag = DisposeBag()
    
    let entries = MutableObservableArray<Entry>([])
    var category: Category? {
        didSet {
            self.setup()
        }
    }
    let categoryName = Observable<String>("")
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    /// Sets up/populates observables.
    func setup() {
        categoryName.value = category!.name
        dataSource.entries(under: category!)
            .observeNext { [unowned self] in
                self.entries.replace(with: $0, performDiff: false)
            }.dispose(in: bag)
    }
    
    /// Moves entries up/down. This method is called when an entry has been drag & dropped in the table view.
    ///
    /// - Parameter from: Index where the d&d started.
    /// - Parameter to: Index where the d&d ended.
    func moveItem(from: Int, to: Int) {
        self.entries.moveItem(from: from, to: to)
        self.reindexEntries()
    }
    
    /// Removes item fully from the database.
    ///
    /// - Parameter index: Index of the entry to be deleted.
    func removeItem(index: Int) {
        let entry = self.entries[index]
        dataSource.delete(entry: entry, from: category!)
        self.reindexEntries()
    }
    
    /// Decides whether entries need reindexing.
    /// - Example 1: [0, 1, 3, 6] would return true
    /// - Example 2: [0, 1, 2, 3] would return false
    ///
    /// - Returns: Boolean flag indicating non-even ordering.
    private func needsReindexing() -> Bool {
        for index in 0..<entries.count {
            let entry = entries[index]
            if entry.order != index {
                return true
            }
        }
        
        return false
    }
    
    /// Reindexes the order of the entries so that they are evenly ordered (0,1,2..).
    private func reindexEntries() {
        if needsReindexing() {
            for index in 0..<self.entries.count {
                let entry = self.entries[index]
                entry.order = index
            }
            dataSource.update(batch: entries.map { $0 })
        }
    }
    
    /// Changes the name of the category.
    ///
    /// - Parameter name: New name for the category.
    func renameCategory(name: String) {
        categoryName.value = name
        category?.name = name
        dataSource.update(category!)
    }
    
    /// Removes the whole category along with its entries.
    func removeCategory() {
        self.entries.forEach { dataSource.delete($0) }
        dataSource.delete(category!)
    }
}
