//
//  CustomCriteriaTableViewCell.swift
//  URLRemote
//
//  Created by Michal Švácha on 26/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Material

///
class CustomCriteriaTableViewCell: UITableViewCell {
    var criteriaField: TextField?
    var infoButton: UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let container = self.viewWithTag(10)!
        
        self.criteriaField = container.viewWithTag(1) as? TextField
        self.criteriaField?.placeholder = NSLocalizedString("CUSTOM_CRITERIA", comment: "")
        self.criteriaField?.font = RobotoFont.regular(with: 13)
        self.criteriaField?.placeholderActiveColor = UIColor(named: .green).darker()
        self.criteriaField?.dividerActiveColor = UIColor(named: .green).darker()
        self.criteriaField?.isClearIconButtonEnabled = true
        self.criteriaField?.detailColor = UIColor(named: .red)
        
        self.infoButton = container.viewWithTag(2) as? UIButton
        self.infoButton?.tintColor = UIColor(named: .green)
        
        self.selectionStyle = .none
    }
}