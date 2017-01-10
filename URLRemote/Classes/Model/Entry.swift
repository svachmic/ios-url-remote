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
    
    func toString() -> String {
        switch self {
        case .Custom:
            return NSLocalizedString("TYPE_CUSTOM", comment: "")
        case .SimpleHTTP:
            return NSLocalizedString("TYPE_SIMPLE_HTTP", comment: "")
        case .Quido:
            return NSLocalizedString("TYPE_QUIDO", comment: "")
        }
    }
}

///
class Entry: Mappable {
    var name: String?
    var color: ColorName?
    var icon: String?
    var url: String?
    var type: EntryType?
    var requiresAuthentication = false
    var user: String?
    var password: String?
    
    init() {}
    
    // MARK: - ObjectMapper methods
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name <- map["name"]
        color <- map["color"]
        icon <- map["icon"]
        url <- map["url"]
        type <- map["type"]
        requiresAuthentication <- map["requiresAuthentication"]
        user <- map["user"]
        password <- map["password"]
    }
}
