//
//  MockDataSource.swift
//  URLRemote
//
//  Created by Michal Švácha on 27/08/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit
@testable import URLRemote

/// Mocked DataSource object for testing purposes - avoids reads/writes directly in Firebase. 
class MockDataSource: DataSource {
    var categoriesDict = MutableObservableDictionary<String, URLRemote.Category>()
    let entriesDict = MutableObservableDictionary<String, Entry>()
    let bag = DisposeBag()
    
    init() {}
    
    /// MARK: - Categories
    
    func categories() -> Signal<[URLRemote.Category], NoError> {
        return categoriesDict.toSignal().map { dict in
            return Array(dict.source.dictionary.values.map{ $0 }).sorted()
        }
    }
    
    func update(_ category: URLRemote.Category) {
        if category.firebaseKey == nil {
            category.firebaseKey = randomString(length: 8)
        }
        
        _ = categoriesDict.updateValue(category, forKey: category.firebaseKey!)
    }
    
    func delete(_ category: URLRemote.Category) {
        _ = categoriesDict.removeValue(forKey: category.firebaseKey!)
    }
    
    /// MARK: - Entries
    
    func entries() -> Signal<[Entry], NoError> {
        return entriesDict.toSignal().map { dict in
            return Array(dict.source.dictionary.values.map{ $0 }).sorted()
        }
    }
    
    func update(_ entry: Entry) {
        if entry.firebaseKey == nil {
            entry.firebaseKey = randomString(length: 8)
        }
        
        _ = entriesDict.updateValue(entry, forKey: entry.firebaseKey!)
    }
    
    func delete(_ entry: Entry) {
        _ = entriesDict.removeValue(forKey: entry.firebaseKey!)
    }
    
    // MARK: - Mock helpers
    
    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func generateEntries(count: Int) -> [Entry] {
        return (0..<count).map {
            let e = Entry()
            e.firebaseKey = randomString(length: 8)
            e.name = "e\($0)"
            e.order = $0
            return e
        }
    }
    
    func generateCategories(count: Int) -> [URLRemote.Category] {
        return (0..<count).map {
            let c = Category()
            c.firebaseKey = randomString(length: 8)
            c.name = "c\($0)"
            c.order = $0
            return c
        }
    }
    
    func fillWithTestData() {
        let categoryCount = 3
        var entriesCategoryCount = [3, 9, 1]
        
        if categoryCount != entriesCategoryCount.count {
            fatalError("Tests will fail unless the counts are right.")
        }
        
        let categories = generateCategories(count: categoryCount)
        for index in 0..<categories.count {
            let category = categories[index]
            let entries = generateEntries(count: entriesCategoryCount[index])
            for e in entries {
                self.add(e, to: category)
            }
        }
    }
}
