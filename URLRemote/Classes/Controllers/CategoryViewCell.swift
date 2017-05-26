//
//  CategoryViewCell.swift
//  URLRemote
//
//  Created by Michal Švácha on 26/05/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Material

/// View for a category represented by a section header in a collection view. Drawn with transparent background and a label with the name of the category.
class CategoryViewCell: UICollectionReusableView {
    var label: UILabel?
    
    /// Sets up the label
    func setUpView() {
        if label == nil {
            label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            label?.font = RobotoFont.bold(with: 40.0)
            label?.textAlignment = .center
            label?.textColor = .lightGray
            self.addSubview(label!)
        }
    }
    
    /// Sets the text of the label to be the name of the category it represents.
    ///
    /// - Parameter category: Category model object with the data about the category.
    func bind(with category: Category) {
        label?.text = "- \(category.name) -"
    }
}
