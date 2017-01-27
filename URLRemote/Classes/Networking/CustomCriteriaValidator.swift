//
//  File.swift
//  URLRemote
//
//  Created by Michal Švácha on 27/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation

///
class CustomCriteriaValidator: GenericValidator {
    
    ///
    override func validateOutput(output: String) -> Bool {
        return self.criteria
            .components(separatedBy: " ")
            .map { output.contains($0) }
            .reduce(false) { $0 || $1 }
    }
}
