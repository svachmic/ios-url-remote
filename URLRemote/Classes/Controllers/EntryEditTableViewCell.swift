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
class EntryEditTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editButton: IconButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.font = RobotoFont.bold(with: 14)
        editButton.image = Icon.cm.edit
        editButton.tintColor = .gray
    }
}
