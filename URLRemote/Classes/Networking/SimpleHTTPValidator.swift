//
//  SimpleHTTPValidator.swift
//  URLRemote
//
//  Created by Michal Švácha on 23/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation

/// Simple HTTP validator for validating output based on HTTP status code.
class SimpleHTTPValidator: GenericValidator {
    
    /// Custom initializer because no criteria is needed.
    convenience init() {
        self.init(with: "")
    }
    
    /// Hidden initializer from GenericValidator because this object should not be initialized with any criteria.
    private override init(with criteria: String) {
        super.init(with: criteria)
    }
    
    /// Returns always true, because status code checking is done on the layer above, where the URL call is performed. Any output passed is omitted.
    ///
    /// - Parameter output: The output from the device after the action has been performed.
    /// - Returns: True. Always.
    override func validateOutput(output: String) -> Bool {
        return true
    }
}
