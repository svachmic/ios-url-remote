//
//  ActionsViewModel.swift
//  URLRemote
//
//  Created by Michal Švácha on 13/12/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit

/// View Model for the main Actions screen. Handles categories/entries grid data.
class ActionsViewModel {
    let dataSource = Observable<DataSource?>(nil)
    var data = MutableObservable2DArray<Category, Entry>([])
    var combiner: Disposable?
    let bag = DisposeBag()
    
    init() {
        dataSource.observeNext { [unowned self] dataSource in
            if let dataSource = dataSource {
                self.combiner = combineLatest(
                    dataSource.categories(),
                    dataSource.entries()) { [unowned self] in
                        return self.merge(categories: $0, entries: $1)
                    }.observeNext { [unowned self] in
                        self.data.replace(with: $0, performDiff: false)
                    }
            } else {
                self.combiner?.dispose()
                self.data.removeAllItems()
            }
        }.dispose(in: bag)
    }
    
    /// Merges given categories and entries and creates one structure.
    ///
    /// - Parameter categories: Categories from data source.
    /// - Parameter entries: Entries from data source.
    /// - Returns: Two-dimensional array of categories-objects.
    private func merge(categories: [Category], entries: [Entry]) -> MutableObservable2DArray<Category, Entry> {
        let contents = MutableObservable2DArray<Category, Entry>([])
        
        for category in categories {
            let section = Observable2DArraySection<Category, Entry>(
                metadata: category,
                items: entries.filter { category.contains(entry: $0) }
            )
            contents.appendSection(section)
        }
        
        return contents
    }
    
    /// Creates a new category and persists it.
    ///
    /// - Parameter name: Name of the category.
    func createCategory(named name: String) {
        let category = Category()
        category.name = name
        category.order = self.data.numberOfSections
        self.dataSource.value?.update(category)
    }
}
