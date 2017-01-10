//
//  TypeEntryTableViewCell.swift
//  URLRemote
//
//  Created by Michal Švácha on 09/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Material

class TypeEntryTableViewCell: UITableViewCell {
    var button: FlatButton?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let container = self.viewWithTag(10)!
        
        self.button = container.viewWithTag(1) as? FlatButton
        self.button?.titleColor = .black
        self.button?.titleLabel?.font = RobotoFont.bold(with: 13)
        self.button?.contentHorizontalAlignment = .left
        self.button?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 0)
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
