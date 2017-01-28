//
//  ValidatorFactory.swift
//  URLRemote
//
//  Created by Michal Švácha on 23/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation

/// Factory for creating specific Validator instances for the type of the Entry.
class ValidatorFactory {
    
    /// Returns a specific Validator for the Entry. If no type is specified, SimpleHTTPValidator is created.
    ///
    /// - Parameter entry: Entry for which the Validator should be created.
    /// - Returns: The specific Validator for the Entry.
    class func validator(for entry: Entry) -> Validator {
        switch entry.type {
        case .none:
            return SimpleHTTPValidator()
        case .some(.SimpleHTTP):
            return SimpleHTTPValidator()
        case .some(.Quido):
            return QuidoValidator()
        case .some(.Custom):
            return CustomCriteriaValidator(with: entry.customCriteria)
        }
    }
}
