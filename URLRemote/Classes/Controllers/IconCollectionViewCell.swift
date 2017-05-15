//
//  IconCollectionViewCell.swift
//  URLRemote
//
//  Created by Michal Švácha on 12/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit

///
class IconCollectionViewCell: UICollectionViewCell {
    ///
    var highlightLayer: CAShapeLayer?
    
    ///
    func highlight() {
        if let highlightLayer = self.highlightLayer {
            self.layer.addSublayer(highlightLayer)
        } else {
            let circlePath = UIBezierPath(
                arcCenter: CGPoint(x: self.width / 2.0, y: self.width / 2.0),
                radius: self.width / 2.0,
                startAngle: CGFloat(0),
                endAngle:CGFloat(Double.pi * 2),
                clockwise: true)
            
            self.highlightLayer = CAShapeLayer()
            self.highlightLayer?.path = circlePath.cgPath
            self.highlightLayer?.fillColor = UIColor.clear.cgColor
            self.highlightLayer?.strokeColor = UIColor.gray.cgColor
            self.highlightLayer?.lineWidth = 10.0
            
            self.layer.addSublayer(self.highlightLayer!)
        }
    }
    
    ///
    func unhighlight() {
        self.highlightLayer?.removeFromSuperlayer()
    }
}
