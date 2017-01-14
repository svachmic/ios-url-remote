//
//  ShadedView.swift
//  URLRemote
//
//  Created by Michal Švácha on 08/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit

/// View with dropped shadow along its borders.
class ShadedView: UIView {
    
    /// Overriden defualt method - draws the UIView with the shadow.
    ///
    /// - Parameter rect: CGRect object with origin and size for the view.
    override func draw(_ rect: CGRect) {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.9
    }
}
