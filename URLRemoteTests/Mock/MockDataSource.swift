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
}
