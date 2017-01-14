//
//  UIViewGradientExtension.swift
//  URLRemote
//
//  Created by Svacha, Michal on 30/05/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import UIKit

/// UIView extension with utilities used throughout the application.
extension UIView {
    
    /// Adds gradient as background wherever it gets called.
    ///
    /// - Parameter starPoint: Starting point of the grandient.
    /// - Parameter endPoint: Ending point of the gradient.
    /// - Parameter bounds: Bounds for the frame of the view.
    /// - Parameter colors: Colors to make the gradient from.
    func setCustomGradient(startPoint: CGPoint, endPoint: CGPoint, bounds: CGRect, colors: [CGColor]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.frame = bounds
        gradient.colors = colors
        self.layer.insertSublayer(gradient, at: 0)
    }
}
