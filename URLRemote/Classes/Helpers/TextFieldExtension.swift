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

///
extension TextField {
    
    ///
    var bndDetail: Bond<TextField, String> {
        return Bond(target: self) { field, text in
            field.detail = text
        }
    }
}
