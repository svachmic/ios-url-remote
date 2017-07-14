//
//  TypeEntryTableViewCell.swift
//  URLRemote
//
//  Created by Michal Švácha on 09/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Material

/// View for a cell representing the type of an entry. Drawn simply as a text with currently selected type and an arrow indicating interaction with the cell.
class GenericButtonTableViewCell: UITableViewCell {
    var button: FlatButton?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// Has to be called in order to set up all the subviews. Container with tag 10 is otherwise nil before the super method is called.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let container = self.viewWithTag(10)!
        
        self.button = container.viewWithTag(1) as? FlatButton
        self.button?.titleColor = .gray
        self.button?.titleLabel?.font = RobotoFont.bold(with: 13)
        self.button?.contentHorizontalAlignment = .left
        self.button?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 0)
        
        let imageView = self.viewWithTag(2) as? UIImageView
        imageView?.image = UIImage(named: "arrow_right")!.withRenderingMode(.alwaysTemplate)
        imageView?.tintColor = .gray
        
        self.selectionStyle = .none
    }
}
