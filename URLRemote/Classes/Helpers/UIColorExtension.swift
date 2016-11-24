//
//  UIColorExtension.swift
//  URLRemote
//
//  Created by Svacha, Michal on 30/05/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import UIKit

/// UIColor extension supporting Name declaration in order to prevent tedious RGB initialization.
///
/// Inspired by article by @aligatr available at:
/// http://alisoftware.github.io/swift/enum/constants/2015/07/19/enums-as-constants/
extension UIColor {
    
    /// Enum values of additional colors.
    enum Name: UInt32 {
        case green = 0x268988ff
        case transparentBlack = 0x00000088
        case cloudBlue = 0x70a2cbff
        case darkerGreen = 0x28a4b7ff
        case gradientStart = 0xb4e6e6ff
        case gradientEnd = 0xe9f2d7ff
        
        case gradientBackgroundStart = 0x00d5b4ff
        case gradientBackgroundMiddle = 0x00b3c2ff
        case gradientBackgroundEnd = 0x0070dbff
        
        case red = 0xec704fff
        case yellow = 0xf8c861ff
        case greener = 0x62c9b7ff
        case gray = 0xeaeaeaff
    }
    
    /// Convenience initializer to initialize color with a given Name enum value.
    ///
    /// - parameter name: Enum Name value representing one of the additional colors.
    convenience init(named name: Name) {
        let RGBAValue = name.rawValue
        let R = CGFloat((RGBAValue >> 24) & 0xff) / 255.0
        let G = CGFloat((RGBAValue >> 16) & 0xff) / 255.0
        let B = CGFloat((RGBAValue >> 8) & 0xff) / 255.0
        let alpha = CGFloat((RGBAValue) & 0xff) / 255.0
        
        self.init(red: R, green: G, blue: B, alpha: alpha)
    }
    
    func darker() -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(
                red: max(r - 0.1, 0.0),
                green: max(g - 0.1, 0.0),
                blue: max(b - 0.1, 0.0),
                alpha: a)
        }
        
        return UIColor()
    }
}
