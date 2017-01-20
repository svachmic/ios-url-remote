//
//  ActionValidator.swift
//  URLRemote
//
//  Created by Michal Švácha on 20/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation

/// Protocol for output validation to be implemented for various EntryTypes.
protocol Validator {
    
    /// Validates the performed action and returns the outcome.
    ///
    /// - Parameter output: The string given on the output.
    /// - Returns: A flag indicating whether or not it was a valid action.
    func validateOutput(output: String) -> Bool
}
