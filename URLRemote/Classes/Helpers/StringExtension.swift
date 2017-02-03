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
    
    /// Function for internal use in the extension - decides whether or not the String matches the given RegEx pattern.
    ///
    /// - Parameter pattern: Regular expression pattern to match.
    /// - Returns: A boolean flag indicating the result of pattern matching.
    private func matches(pattern: String) -> Bool {
        let regex = try! NSRegularExpression(
            pattern: pattern,
            options: [.caseInsensitive])
        return regex.firstMatch(
            in: self,
            options: [],
            range: NSRange(location: 0, length: utf16.count)) != nil
    }
    
    /// Decides whether or not the string is a valid e-mail.
    ///
    /// - Returns: A boolean flag indicating the result.
    func isValidEmail() -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return self.matches(pattern: emailPattern)
    }
    
    /// Decides whether or not the string is a valid URL.
    ///
    /// - Returns: A boolean flag indicating the result.
    func isValidURL() -> Bool {
        guard let url = URL(string: self) else { return false }
        if !UIApplication.shared.canOpenURL(url) {
            return false
        }
        
        let urlPattern = "^(http|https|ftp)\\://([a-zA-Z0-9\\.\\-]+(\\:[a-zA-Z0-9\\.&amp;%\\$\\-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|localhost|([a-zA-Z0-9\\-]+\\.)*[a-zA-Z0-9\\-]+\\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(\\:[0-9]+)*(/($|[a-zA-Z0-9\\.\\,\\?\\'\\\\\\+&amp;%\\$#\\=~_\\-]+))*$"
        return self.matches(pattern: urlPattern)
    }
}
