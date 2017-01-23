//
//  ValidatorFactory.swift
//  URLRemote
//
//  Created by Michal Švácha on 23/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation

///
class ValidatorFactory {
    
    ///
    class func validator(for entry: Entry) -> Validator {
        guard let type = entry.type else {
            return GenericValidator(with: "")
        }
        
        switch type {
        case .SimpleHTTP:
            return SimpleHTTPValidator()
        case .Quido:
            return QuidoValidator()
        case .Custom:
            return GenericValidator(with: "")
        }
    }
}
