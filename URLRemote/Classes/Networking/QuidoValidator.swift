//
//  QuidoValidator.swift
//  URLRemote
//
//  Created by Michal Švácha on 21/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation

/// Quido is a specialized I/O module made by Papouch s.r.o.
/// Website: https://www.papouch.com/cz/shop/products/io-moduly/quido/
/// Tha validator evaluates the output against Quido defined criteria.
class QuidoValidator: GenericValidator {
    
    /// Custom initializer because Quido has an exact output for success.
    convenience init() {
        self.init(with: "1")
    }
    
    /// Hidden initializer from GenericValidator because this object should not be initialized with any other criteria than the one in the initializer above.
    private override init(with criteria: String) {
        super.init(with: criteria)
    }
}
