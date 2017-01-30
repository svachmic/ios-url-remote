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
}
