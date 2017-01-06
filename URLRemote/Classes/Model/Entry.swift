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
enum EntryType: Int {
    case Custom = 0
    case SimpleHTTP = 1
    case Quido = 2
}

///
class Entry: Mappable {
    var color: UInt32?
    var icon: String?
    var url: String?
    var type: EntryType?
    
    init() {}
    
    // MARK: - ObjectMapper methods
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        color <- map["color"]
        icon <- map["icon"]
        url <- map["url"]
        type <- map["type"]
    }
}
