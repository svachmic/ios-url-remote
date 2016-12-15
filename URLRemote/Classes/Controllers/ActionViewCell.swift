//
//  ActionViewCell.swift
//  URLRemote
//
//  Created by Michal Švácha on 14/12/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import UIKit

class ActionViewCell: UICollectionViewCell {
    
    func setUpViews(bounds: CGRect) {
        self.contentView.layer.cornerRadius = self.frame.width / 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.contentView.setCustomGradient(
            startPoint: CGPoint(x: 0.0, y: 0.0),
            endPoint: CGPoint(x: 1.0, y: 1.0),
            bounds: bounds,
            colors: [
                UIColor(named: .gradientBackgroundStart).cgColor,
                UIColor(named: .gradientBackgroundEnd).cgColor
            ])
        
        // no shadows
        //self.layer.shadowColor = UIColor.gray.cgColor
        //self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        //self.layer.shadowRadius = 2.0
        //self.layer.shadowOpacity = 1.0
        //self.layer.masksToBounds = false
        
        if let label = self.viewWithTag(5) as? UILabel {
            label.text = String(format: "%@%@", arguments: ["YO", ""])
        } else {
            let height = self.frame.height * 0.8
            let y = (self.frame.height - height) * 0.5
            let label = UILabel(frame: CGRect(x: 0, y: y, width: self.frame.width, height: height))
            label.tag = 5
            
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont.boldSystemFont(ofSize: 70)
            label.text = String(format: "%@%@", arguments: ["YO", ""])
            label.textColor = UIColor.white
            label.numberOfLines = 1
            label.minimumScaleFactor = 8/label.font.pointSize
            label.adjustsFontSizeToFitWidth = true
            
            self.addSubview(label)
        }
    }
}
