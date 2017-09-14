//
//  IconSectionCollectionReusableView.swift
//  URLRemote
//
//  Created by Michal Švácha on 13/09/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Material

/// View responsible for displaying a section header for cells of icons.
class IconSectionCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var sectionNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sectionNameLabel.font = RobotoFont.bold(with: 14)
        sectionNameLabel.textColor = .gray
    }
}
