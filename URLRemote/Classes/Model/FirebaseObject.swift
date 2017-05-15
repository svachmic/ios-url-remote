//
//  FirebaseObject.swift
//  URLRemote
//
//  Created by Michal Švácha on 30/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import ObjectMapper

/// Superclass for all Firebase objects.
class FirebaseObject: Equatable, Mappable, Comparable {
    /// Internal Firebase Key for editing functions and binding.
    var firebaseKey: String?
    /// Order of the object for easy sorting.
    var order: Int = 0
    
    init() {}
    
    // MARK: - ObjectMapper methods
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        firebaseKey <- map["firebaseKey"]
        order <- map["order"]
    }
    
    // MARK: - Comparable method
    
    static func < (lhs: FirebaseObject, rhs: FirebaseObject) -> Bool {
        return lhs.order < rhs.order
    }
    
    // MARK: - Equatable method
    
    /// Equation method comparing two entries.
    ///
    /// - Parameter lhs: First entry to be compared.
    /// - Parameter rhs: Second entry to be compared.
    /// - Returns: True only if the Firebase keys exist on both entries and are equal.
    static func == (lhs: FirebaseObject, rhs: FirebaseObject) -> Bool {
        if let lhsFIRKey = lhs.firebaseKey, let rhsFIRKey = rhs.firebaseKey, lhsFIRKey == rhsFIRKey {
            return true
        }
        
        return false
    }
}
