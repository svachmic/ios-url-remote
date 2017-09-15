//
//  DesignEntryTableViewCell.swift
//  URLRemote
//
//  Created by Michal Švácha on 09/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import ReactiveKit
import Bond
import Material

/// ReactiveKit extension to enable direct binding.
extension ReactiveExtensions where Base: DesignEntryTableViewCell {
    
    /// Binding with the iconButton after the icon has been changed.
    var iconImage: Bond<UIImage?> {
        return bond { cell, image in
            if let i = image {
                cell.iconButton.image = i.withRenderingMode(.alwaysTemplate)
                cell.iconButton.imageView?.tintColor = .white
            }
        }
    }
}

/// View responsible for displaying the icon, color and name of an entry.
class DesignEntryTableViewCell: UITableViewCell {
    @IBOutlet weak var iconButton: FlatButton!
    @IBOutlet weak var nameField: TextField!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorSelector: ColorSelectorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconButton.pulseColor = .white
        iconButton.tintColor = .white
        iconButton.imageEdgeInsets = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
        iconButton.layer.cornerRadius = iconButton.frame.width / 2.0
        
        nameField.placeholder = NSLocalizedString("ENTRY_NAME", comment: "")
        nameField.font = RobotoFont.regular(with: 13)
        nameField.placeholderActiveColor = UIColor(named: .green).darker()
        nameField.dividerActiveColor = UIColor(named: .green).darker()
        nameField.isClearIconButtonEnabled = true
        nameField.detailColor = UIColor(named: .red)
        nameField.autocorrectionType = .no
        
        colorLabel.font = RobotoFont.bold(with: 12)
        colorLabel.text = "\(NSLocalizedString("COLOR", comment: "")):"
        colorLabel.textColor = .gray
        
        self.selectionStyle = .none
    }
}
