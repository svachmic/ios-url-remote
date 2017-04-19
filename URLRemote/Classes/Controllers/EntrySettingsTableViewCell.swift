//
//  EntrySettingsTableViewCell.swift
//  URLRemote
//
//  Created by Michal Švácha on 18/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Material

///
class EntrySettingsTableViewCell: UITableViewCell {
    var label: UILabel?
    var button: IconButton?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// Has to be called in order to set up all the subviews. Container with tag 10 is otherwise nil before the super method is called.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.label = self.viewWithTag(1) as? UILabel
        self.label?.font = RobotoFont.bold(with: 14)
        
        self.button = self.viewWithTag(2) as? IconButton
        self.button?.image = Icon.cm.edit
        self.button?.tintColor = .gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
