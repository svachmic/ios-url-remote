//
//  DesignEntryTableViewCell.swift
//  URLRemote
//
//  Created by Michal Švácha on 09/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Material

class DesignEntryTableViewCell: UITableViewCell {
    var icon: FlatButton?
    var nameField: TextField?
    var colorSelector: ColorSelectorView?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let container = self.viewWithTag(10)!
        
        self.icon = container.viewWithTag(1) as? FlatButton
        self.icon?.pulseColor = .white
        self.icon?.tintColor = .white
        self.icon?.imageEdgeInsets = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
        self.icon?.layer.cornerRadius = self.icon!.frame.width / 2.0
        
        self.nameField = self.viewWithTag(2) as? TextField
        self.nameField?.placeholder = NSLocalizedString("ENTRY_NAME", comment: "")
        self.nameField?.font = RobotoFont.regular(with: 13)
        self.nameField?.placeholderActiveColor = UIColor(named: .green).darker()
        self.nameField?.dividerActiveColor = UIColor(named: .green).darker()
        self.nameField?.isClearIconButtonEnabled = true
        self.nameField?.detailColor = UIColor(named: .red)
        
        self.colorSelector = container.viewWithTag(4) as? ColorSelectorView
        
        let label = self.viewWithTag(3) as? UILabel
        label?.font = RobotoFont.bold(with: 12)
        label?.text = "\(NSLocalizedString("COLOR", comment: "")):"
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
