//
//  UIViewGradientExtension.swift
//  URLRemote
//
//  Created by Svacha, Michal on 30/05/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import UIKit
import Foundation

/// Adds gradient as background wherever it gets called.
extension UIView {
    func setCustomGradient(startPoint: CGPoint, endPoint: CGPoint, bounds: CGRect, colors: [CGColor]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.frame = bounds
        gradient.colors = colors
        self.layer.insertSublayer(gradient, at: 0)
    }
}
