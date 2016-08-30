//
//  UIColorExtension.swift
//  URLRemote
//
//  Created by Svacha, Michal on 30/05/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import UIKit

/**
 UIColor extension supporting Name declaration in order to prevent tedious RGB initialization.
 */
extension UIColor {
    
    /**
     Enum values of additional colors.
     */
    enum Name: UInt32 {
        case Green = 0x268988ff
        case UltraLightGray = 0xeaeaeaff
        case TransparentBlack = 0x00000088
        case CloudBlue = 0x70a2cbff
        case DarkerGreen = 0x28a4b7ff
        case GradientStart = 0xb4e6e6ff
        case GradientEnd = 0xe9f2d7ff
        
        case GradientBackgroundStart = 0x00d5b4ff
        case GradientBackgroundMiddle = 0x00b3c2ff
        case GradientBackgroundEnd = 0x0070dbff
    }
    
    /**
     Convenience initializer to initialize color with given Name.
     
     - parameter name: Enum Name value representing one of the additional colors.
     */
    convenience init(named name: Name) {
        let RGBAValue = name.rawValue
        let R = CGFloat((RGBAValue >> 24) & 0xff) / 255.0
        let G = CGFloat((RGBAValue >> 16) & 0xff) / 255.0
        let B = CGFloat((RGBAValue >> 8) & 0xff) / 255.0
        let alpha = CGFloat((RGBAValue) & 0xff) / 255.0
        
        self.init(red: R, green: G, blue: B, alpha: alpha)
    }
}
