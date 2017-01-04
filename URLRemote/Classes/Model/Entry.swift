//
//  Entry.swift
//  URLRemote
//
//  Created by Michal Švácha on 13/12/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import Foundation
import ObjectMapper

///
class Entry: Mappable {
    var color: UInt32?
    var icon: String?
    var url: String?
    
    init() {}
    
    // MARK: - ObjectMapper methods
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        color <- map["color"]
        icon <- map["icon"]
        url <- map["url"]
    }
}
