//
//  IconCollectionViewCell.swift
//  URLRemote
//
//  Created by Michal Švácha on 12/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit

/// View responsible for displaying an icon and reflect the state of being selected or not.
class IconCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    
    /// Layer used for highlighting the cell by drawing a circle around.
    var highlightLayer: CAShapeLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = frame.width / 2.0
    }
    
    /// Sets the icon of the cell with the given name. Fails silently.
    ///
    /// - Parameter imageName: Name of the image resource.
    func setIcon(named imageName: String) {
        guard let image = UIImage(named: imageName) else { return }
        
        iconImageView.image = image.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = .white
    }
    
    /// Highlights or unhighlights the cell based on the passed parameter.
    ///
    /// - Parameter isHighlighted: Boolean flag indicating the state of the cell.
    func setIsHighlighted(_ isHighlighted: Bool) {
        if isHighlighted {
            highlight()
        } else {
            unhighlight()
        }
    }
    
    // MARK: - Helper methods
    
    /// Highlights the cell by drawing a circle around it in a cached layer.
    private func highlight() {
        if let highlightLayer = self.highlightLayer {
            self.layer.addSublayer(highlightLayer)
        } else {
            let circlePath = UIBezierPath(
                arcCenter: CGPoint(x: frame.width / 2.0, y: frame.width / 2.0),
                radius: frame.width / 2.0,
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
    
    /// Unhighlights the cell by removing the cached layer from the canvas.
    private func unhighlight() {
        self.highlightLayer?.removeFromSuperlayer()
    }
}
