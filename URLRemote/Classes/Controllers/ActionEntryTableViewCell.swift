//
//  ActionEntryTableViewCell.swift
//  URLRemote
//
//  Created by Michal Švácha on 09/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Material
import Bond

class ActionEntryTableViewCell: UITableViewCell {
    var urlField: TextField?
    var checkbox: CheckboxButton?
    var userField: TextField?
    var passwordField: TextField?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let container = self.viewWithTag(10)!
        
        self.urlField = container.viewWithTag(1) as? TextField
        self.urlField?.placeholder = NSLocalizedString("URL", comment: "")
        self.urlField?.font = RobotoFont.regular(with: 13)
        self.urlField?.placeholderActiveColor = UIColor(named: .green).darker()
        self.urlField?.dividerActiveColor = UIColor(named: .green).darker()
        self.urlField?.isClearIconButtonEnabled = true
        self.urlField?.detailColor = UIColor(named: .red)
        
        self.checkbox = container.viewWithTag(2) as? CheckboxButton
        self.checkbox?.tintColor = .gray
        
        let checkboxLabel = container.viewWithTag(3) as? UILabel
        checkboxLabel?.text = NSLocalizedString("REQUIRES_AUTH", comment: "")
        checkboxLabel?.font = RobotoFont.bold(with: 13)
        checkboxLabel?.textColor = .gray
        
        self.userField = container.viewWithTag(4) as? TextField
        self.userField?.placeholder = NSLocalizedString("USER", comment: "")
        self.userField?.font = RobotoFont.regular(with: 13)
        self.userField?.placeholderActiveColor = UIColor(named: .green).darker()
        self.userField?.dividerActiveColor = UIColor(named: .green).darker()
        self.userField?.isClearIconButtonEnabled = true
        self.userField?.detailColor = UIColor(named: .red)
        
        self.passwordField = container.viewWithTag(5) as? TextField
        self.passwordField?.placeholder = NSLocalizedString("PASSWORD", comment: "")
        self.passwordField?.font = RobotoFont.regular(with: 13)
        self.passwordField?.placeholderActiveColor = UIColor(named: .green).darker()
        self.passwordField?.dividerActiveColor = UIColor(named: .green).darker()
        self.passwordField?.isClearIconButtonEnabled = true
        self.passwordField?.detailColor = UIColor(named: .red)
        
        self.checkbox?.isChecked.bind(to: self.userField!.reactive.isEnabled)
        self.checkbox?.isChecked.bind(to: self.passwordField!.reactive.isEnabled)
        _ = self.checkbox?.isChecked.observeNext {
            let alpha: CGFloat = $0 ? 1.0 : 0.5
            self.userField?.alpha = alpha
            self.passwordField?.alpha = alpha
        }
        
        self.selectionStyle = .none
    }
}
