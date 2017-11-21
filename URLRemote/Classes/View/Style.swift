//
//  Style.swift
//  URLRemote
//
//  Created by Michal Švácha on 21/01/2018.
//  Copyright © 2018 Svacha, Michal. All rights reserved.
//

import UIKit

/// Style struct helping designing components.
public struct Style<View: UIView> {
    
    /// Stored property with styling closure.
    public let style: (View) -> Void
    
    /// Initializer taking UIView and its styling logic.
    ///
    /// - Parameter style: Closure with UIView styling.
    public init(_ style: @escaping (View) -> Void) {
        self.style = style
    }
    
    /// Applies style to a given UIView subclass.
    ///
    /// - Parameter view: UIView sublass to which style should be applied.
    public func apply(to view: View) {
        style(view)
    }
}

/// Extension for UIView implementing styling methods.
extension UIView {
    
    /// Convenience initializer for applying the style in init method.
    ///
    /// - Parameter style: Style to be applied.
    public convenience init<T>(style: Style<T>) {
        self.init(frame: .zero)
        apply(style)
    }
    
    /// Applies the given style.
    ///
    /// - Parameter style: Style to be applied.
    public func apply<T>(_ style: Style<T>) {
        guard let view = self as? T else {
            return
        }
        style.apply(to: view)
    }
}
