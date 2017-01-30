//
//  Entry.swift
//  URLRemote
//
//  Created by Michal Švácha on 13/12/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import Foundation
import ObjectMapper

/// Enum for all the Entry types.
/// Represented by an integer in order for it to be easily serializable from/to online database.
enum EntryType: Int, EnumCollection {
    
    /// Custom criteria type evaluated against a user-defined criteria.
    case Custom = 0
    
    /// Simple HTTP type evaluated only by HTTP status code.
    case SimpleHTTP = 1
    
    /// Quido I/O module type evaluated against specific criteria.
    case Quido = 2
    
    /// Returns human-readable, localized name of the enum value.
    ///
    /// - Returns: String object with the name of the EntryType.
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
    
    /// Returns human-readable, localized description of the enum value.
    ///
    /// - Returns: String object with the description of the EntryType.
    func description() -> String {
        switch self {
        case .Custom:
            return NSLocalizedString("TYPE_CUSTOM_DESC", comment: "")
        case .SimpleHTTP:
            return NSLocalizedString("TYPE_SIMPLE_HTTP_DESC", comment: "")
        case .Quido:
            return NSLocalizedString("TYPE_QUIDO_DESC", comment: "")
        }
    }
}

/// Model class for an Entry. An entry represents one callable IoT device action.
class Entry: Mappable, Equatable {
    /// Internal Firebase Key for editing functions and binding.
    var firebaseKey: String?
    /// Order of the entry in the list/collection.
    var order: Int = 0
    /// User-defined name for the entry.
    var name: String?
    /// Color of the entry from the application specific range of colors.
    var color: ColorName?
    /// Name of the icon in the icon set.
    var icon: String?
    /// URL for the action.
    var url: String?
    /// Type of the entry.
    var type: EntryType?
    /// Flag indicating whether the URL also needs HTTP Authentication.
    var requiresAuthentication = false
    /// Username for HTTP Authentication.
    var user: String?
    /// Password for HTTP Authentication.
    var password: String?
    /// User-defined criteria for EntryType Custom.
    var customCriteria: String = ""
    
    init() {}
    
    // MARK: - ObjectMapper methods
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        firebaseKey <- map["firebaseKey"]
        order <- map["order"]
        name <- map["name"]
        color <- map["color"]
        icon <- map["icon"]
        url <- map["url"]
        type <- map["type"]
        requiresAuthentication <- map["requiresAuthentication"]
        user <- map["user"]
        password <- map["password"]
    }
    
    // MARK: - Equatable method
    
    /// Equation method comparing two entries.
    ///
    /// - Parameter lhs: First entry to be compared.
    /// - Parameter rhs: Second entry to be compared.
    /// - Returns: True only if the Firebase keys exist on both entries and are equal.
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        if let lhsFIRKey = lhs.firebaseKey, let rhsFIRKey = lhs.firebaseKey, lhsFIRKey == rhsFIRKey {
            return true
        }
        
        return false
    }
}
