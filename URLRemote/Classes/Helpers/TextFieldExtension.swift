//
//  TextFieldExtension.swift
//  URLRemote
//
//  Created by Michal Švácha on 24/11/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import Foundation
import Material
import Bond

/// TextField extension for reactive binding
extension TextField {
    
    /// computed variable Bond allowing binding with a String object
    var bndDetail: Bond<TextField, String> {
        return Bond(target: self) { field, text in
            field.detail = text
        }
    }
}
