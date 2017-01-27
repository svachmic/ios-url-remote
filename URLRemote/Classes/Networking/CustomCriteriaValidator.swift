//
//  File.swift
//  URLRemote
//
//  Created by Michal Švácha on 27/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation

/// Custom criteria validator for evaluating the output against user-defined criteria.
class CustomCriteriaValidator: GenericValidator {
    
    /// Validates the output from the action by dividing the criteria into separate words (divided by a space) and then chaining them into a sequence of logical OR functions. 
    /// If one of the words appear in the ouput, the whole action is evaluated as true.
    ///
    /// - Parameter output: The output from the device after the action has been performed.
    /// - Returns: Boolean flag indicating whether or not the output matched the criteria.
    override func validateOutput(output: String) -> Bool {
        return self.criteria
            .components(separatedBy: " ")
            .map { output.contains($0) }
            .reduce(false) { $0 || $1 }
    }
}
