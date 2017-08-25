//
//  MockDataSource.swift
//  URLRemote
//
//  Created by Michal Švácha on 27/08/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import ReactiveKit
@testable import URLRemote

///
class MockDataSource: DataSource {
    var categories: [URLRemote.Category] = []
    let categoriesPublisher = SafePublishSubject<[URLRemote.Category]>()
    
    var entries: [Entry] = []
    var entriesPublisher = SafePublishSubject<[Entry]>()
    
    init() {
        ///
    }
    
    func categoriesSignal() -> Signal<[URLRemote.Category], NoError> {
        return categoriesPublisher.toSignal()
    }
    
    func write(_ category: URLRemote.Category) {
        categories.append(category)
        categoriesPublisher.next(categories)
    }
    
    func delete(_ category: URLRemote.Category) {
        guard let key = category.firebaseKey else {
            return
        }
        
        var index = 0
        for cat in categories {
            if let f1 = cat.firebaseKey, f1 == key {
                categories.remove(at: index)
            }
            index += 1
        }
        
        categoriesPublisher.next(categories)
    }
    
    func entriesSignal() -> Signal<[Entry], NoError> {
        return entriesPublisher.toSignal()
    }
    
    func write(entry: Entry, category: URLRemote.Category) {
        entries.append(entry)
        categories.append(category)
        entriesPublisher.next(entries)
        categoriesPublisher.next(categories)
    }
    
    func write(_ entry: Entry) {
        ///
    }
    
    func delete(_ entry: Entry) {
        ///
    }
    
    func move(entry: Entry, from: URLRemote.Category, to: URLRemote.Category, shuffleOrder: Bool) {
        ///
    }
    
}
