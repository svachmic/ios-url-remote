//
//  TypeEntryTableViewCell.swift
//  URLRemote
//
//  Created by Michal Švácha on 09/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Material

/// View responsible for displaying some information (type, category, etc.) of an entry that can be changed by a press of the button.
class GenericButtonTableViewCell: UITableViewCell {
    @IBOutlet weak var button: FlatButton!
    @IBOutlet weak var arrowImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        button.titleColor = .gray
        button.titleLabel?.font = RobotoFont.bold(with: 13)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 0)
        
        arrowImageView.image = UIImage(named: "arrow_right")!.withRenderingMode(.alwaysTemplate)
        arrowImageView.tintColor = .gray
        
        self.selectionStyle = .none
    }
}
