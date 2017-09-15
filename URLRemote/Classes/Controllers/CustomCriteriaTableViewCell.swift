//
//  CustomCriteriaTableViewCell.swift
//  URLRemote
//
//  Created by Michal Švácha on 26/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Material

/// Cell displayed only when Custom criteria is selected as the action type. Displays a text field to type custom string to be evaluated against the action's result.
class CustomCriteriaTableViewCell: UITableViewCell {
    @IBOutlet weak var criteriaField: TextField!
    @IBOutlet weak var infoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        criteriaField.placeholder = NSLocalizedString("CUSTOM_CRITERIA", comment: "")
        criteriaField.font = RobotoFont.regular(with: 13)
        criteriaField.placeholderActiveColor = UIColor(named: .green).darker()
        criteriaField.dividerActiveColor = UIColor(named: .green).darker()
        criteriaField.isClearIconButtonEnabled = true
        criteriaField.detailColor = UIColor(named: .red)
        
        infoButton.tintColor = UIColor(named: .green)
        
        self.selectionStyle = .none
    }
}
