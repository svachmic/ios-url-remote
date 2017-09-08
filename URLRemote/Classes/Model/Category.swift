//
//  Category.swift
//  URLRemote
//
//  Created by Michal Švácha on 30/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import ObjectMapper

/// Model class for a collection of entries.
class Category: FirebaseObject {
    /// User-defined name for the category.
    var name: String = ""
    /// Firebase keys to all entries listed in this category.
    var entryKeys: [String] = []
    
    override init() {
        super.init()
    }
    
    // MARK: - ObjectMapper methods
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        name <- map["name"]
        entryKeys <- map["entryKeys"]
    }
    
    /// Adds entry under this category. Stored only by using unique firebaseKey value. Fails silently.
    ///
    /// - Parameter entry: Entry object to be added.
    func add(entry: Entry) {
        guard let key = entry.firebaseKey else { return }
        
        if !contains(entry: entry) && !isFull() {
            var keys = entryKeys
            entry.order = keys.count
            keys.append(key)
            entryKeys = keys
        }
    }
    
    /// Removes entry from this category. If the firebaseKey is nil, it is considered as removed.
    ///
    /// - Parameter entry: Entry object to be deleted.
    func remove(entry: Entry) {
        guard let key = entry.firebaseKey else { return }
        
        var keys = entryKeys
        if let index = keys.index(of: key) {
            keys.remove(at: index)
            entryKeys = keys
        }
    }
    
    /// Decides whether or not given entry is under this category. If the firebaseKey is nil, it is considered that it is not included.
    ///
    /// - Parameter entry: Entry to be found udner this category.
    /// - Returns: Boolean flag indicating belonging to this category.
    func contains(entry: Entry) -> Bool {
        guard let key = entry.firebaseKey else { return false }
        return entryKeys.contains(key)
    }
    
    /// Decides whether or not the category is capable of
    ///
    /// - Returns: Boolean flag indicating whether the category is full.
    func isFull() -> Bool {
        return entryKeys.count >= 9
    }
}
