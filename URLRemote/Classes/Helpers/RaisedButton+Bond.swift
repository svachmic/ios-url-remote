//
//  RaisedButton+Bond.swift
//  URLRemote
//
//  Created by Michal Švácha on 16/12/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import Foundation
import Material
import Bond
import ReactiveKit

///
extension RaisedButton {
    
    /// computed variable Bond allowing binding with a String object
    var bndAction: Bond<RaisedButton, EntryActionStatus> {
        return Bond(target: self) { button, status in
            print(status)
            button.pulse()
        }
    }
}
