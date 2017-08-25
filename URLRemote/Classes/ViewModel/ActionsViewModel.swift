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

///
class ActionsViewModel {
    var combiner: Disposable?
    let bag = DisposeBag()
    
    let dataSource = Observable<DataSource?>(nil)
    
    
    var data = MutableObservable2DArray<Category, Entry>([])
    
    init() {
        dataSource.observeNext { [unowned self] dataSource in
            if let dataSource = dataSource {
                self.combiner = combineLatest(
                    dataSource.categoriesSignal(),
                    dataSource.entriesSignal()) { (categories, entries) -> MutableObservable2DArray<Category, Entry> in
                        let contents = MutableObservable2DArray<Category, Entry>([])
                    
                        for category in categories {
                            let section = Observable2DArraySection<Category, Entry>(
                                metadata: category,
                                items: entries.filter { category.entryKeys.contains($0.firebaseKey!) }
                            )
                            contents.appendSection(section)
                        }
                    
                        return contents
                    }.observeNext { [unowned self] in
                        self.data.replace(with: $0, performDiff: true)
                    }
            } else {
                self.combiner?.dispose()
                self.data.removeAllItems()
            }
        }.dispose(in: bag)
        
        NotificationCenter.default.reactive.notification(name: DataSourceNotifications.createdEntry.name)
            .observeNext { [unowned self] notification in
                if self.data.count == 0 {
                    return
                }
                
                let entryDto = notification.object as! EntryDto
                let toCategory = self.data[entryDto.categoryIndex].metadata
                
                if let originalIdx = entryDto.originalCategoryIndex, originalIdx != entryDto.categoryIndex {
                    print("this is a change of category")
                    let fromCategory = self.data[originalIdx].metadata
                    self.dataSource.value?.move(entry: entryDto.entry, from: fromCategory, to: toCategory, shuffleOrder: false)
                } else {
                    print("this is either an update or a new category")
                    self.dataSource.value?.write(entry: entryDto.entry, category: toCategory)
                }
            }.dispose(in: self.bag)
    }
}
