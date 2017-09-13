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
                    dataSource.entries()) { (categories, entries) -> MutableObservable2DArray<Category, Entry> in
                        let contents = MutableObservable2DArray<Category, Entry>([])
                    
                        for category in categories {
                            let section = Observable2DArraySection<Category, Entry>(
                                metadata: category,
                                items: entries.filter { category.contains(entry: $0) }
                            )
                            contents.appendSection(section)
                        }
                    
                        return contents
                    }.observeNext { [unowned self] in
                        self.data.replace(with: $0, performDiff: false)
                    }
            } else {
                self.combiner?.dispose()
                self.data.removeAllItems()
            }
        }.dispose(in: bag)
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
