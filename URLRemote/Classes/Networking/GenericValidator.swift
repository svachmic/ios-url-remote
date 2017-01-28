//
//  GenericValidator.swift
//  URLRemote
//
//  Created by Michal Švácha on 22/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation

/// Generic Validator implementation to be mostly overriden by more complex and specific evaluation use-cases.
class GenericValidator: Validator {
    /// Criteria against which the ouput should be evaluated.
    var criteria: String
    
    /// Initializer for the Validator. May be overriden to change behavior slightly - especially if it's to be hidden in subclasses.
    ///
    /// - Parameter criteria: Criteria against which the ouput should be evaluated.
    init(with criteria: String) {
        self.criteria = criteria
    }
    
    /// Validates the output against the criteria.
    ///
    /// - Parameter output: The output from the device after the action has been performed.
    /// - Returns: Boolean flag indicating whether or not the output matched the criteria.
    func validateOutput(output: String) -> Bool {
        return self.criteria == output
    }
}
