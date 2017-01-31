//
//  ArrayExtension.swift
//  URLRemote
//
//  Created by Michal Švácha on 31/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation

/// Array extension with utilities used throughout the application.
extension Array {
    
    /// Enables safe subscripting of an array with non-existing indicies.
    ///
    /// - Parameter index: Index to be looked up.
    /// - Returns: Optional object of the Array's type.
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
