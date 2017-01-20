//
//  SimpleHTTPValidator.swift
//  URLRemote
//
//  Created by Michal Švácha on 23/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation

///
class SimpleHTTPValidator: GenericValidator {
    
    ///
    init() {
        super.init(with: "")
    }
    
    ///
    private override init(with criteria: String) {
        super.init(with: criteria)
    }
    
    ///
    override func validateOutput(output: String) -> Bool {
        return true
    }
}
