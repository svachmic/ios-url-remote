//
//  CategorySelectionTableViewCell.swift
//  URLRemote
//
//  Created by Michal Švácha on 08/09/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Material

/// View responsible for displaying a category and reflect the state of being selected or not.
class CategorySelectionTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryDetailLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        nameLabel.font = RobotoFont.medium(with: 16)
        nameLabel.textColor = .gray
        categoryDetailLabel.font = RobotoFont.regular(with: 12)
        categoryDetailLabel.textColor = .lightGray
        checkImageView.image = Icon.cm.check?.withRenderingMode(.alwaysTemplate)
        checkImageView.tintColor = .gray
        checkImageView.alpha = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    /// Sets up all data in the cell.
    ///
    /// - Parameter category: Model category object from which information are extracted to be displayed.
    /// - Parameter selected: Boolean flag indicating whether or not the checkmark should be displayed.
    func setup(with category: Category, selected: Bool) {
        self.selectionStyle = category.isFull() ? .none : .gray
        nameLabel.text = category.name
        categoryDetailLabel.text = "\(NSLocalizedString("ENTRIES_PLURAL", comment: "")): \(category.entryKeys.count)"
        checkImageView.alpha = selected ? 1.0 : 0.0
        self.contentView.alpha = category.isFull() ? 0.3 : 1.0
    }
}
