//
//  StringExtension.swift
//  URLRemote
//
//  Created by Michal Švácha on 24/11/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import Foundation

/// String extension with utilities used throughout the application.
extension String {
    
    /// Decides whether or not the string is a valid e-mail.
    ///
    /// - Returns: A boolean flag indicating the result.
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(
            pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}",
            options: [.caseInsensitive])
        return regex.firstMatch(
            in: self,
            options:[],
            range: NSRange(location: 0, length: utf16.count)) != nil
    }
}
