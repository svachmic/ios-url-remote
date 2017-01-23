//
//  GenericValidator.swift
//  URLRemote
//
//  Created by Michal Švácha on 22/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation

///
class GenericValidator: Validator {
    ///
    var criteria: String
    
    ///
    init(with criteria: String) {
        self.criteria = criteria
    }
    
    ///
    func validateOutput(output: String) -> Bool {
        return self.criteria == output
    }
}
