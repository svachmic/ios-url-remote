//
//  QuidoValidator.swift
//  URLRemote
//
//  Created by Michal Švácha on 21/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation

///
class QuidoValidator: ActionValidator {
    
    ///
    func validateOutput(output: String) -> Bool {
        return output == "1"
    }
}
