//
//  TypeSelectionTableViewCell.swift
//  URLRemote
//
//  Created by Michal Švácha on 13/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Material

///
class TypeSelectionTableViewCell: UITableViewCell {
    var label: UILabel?
    var infoButton: UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .clear
        
        self.label = self.viewWithTag(1) as? UILabel
        self.label?.font = RobotoFont.medium(with: 16)
        self.label?.textColor = .gray
        
        self.infoButton = self.viewWithTag(2) as? UIButton
        self.infoButton?.tintColor = UIColor(named: .green)
    }
}
