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
    
    /// Has to be called in order to set up all the subviews. Container with tag 10 is otherwise nil before the super method is called.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let container = self.viewWithTag(10)!
        
        urlField = container.viewWithTag(1) as? TextField
        urlField?.autocorrectionType = .no
        urlField?.placeholder = NSLocalizedString("URL", comment: "")
        urlField?.font = RobotoFont.regular(with: 13)
        urlField?.placeholderActiveColor = UIColor(named: .green).darker()
        urlField?.dividerActiveColor = UIColor(named: .green).darker()
        urlField?.isClearIconButtonEnabled = true
        urlField?.detailColor = UIColor(named: .red)
        
        checkbox = container.viewWithTag(2) as? CheckboxButton
        checkbox?.tintColor = .gray
        
        let checkboxLabel = container.viewWithTag(3) as? UILabel
        checkboxLabel?.text = NSLocalizedString("REQUIRES_AUTH", comment: "")
        checkboxLabel?.font = RobotoFont.bold(with: 13)
        checkboxLabel?.textColor = .gray
        
        userField = container.viewWithTag(4) as? TextField
        userField?.placeholder = NSLocalizedString("USER", comment: "")
        userField?.font = RobotoFont.regular(with: 13)
        userField?.placeholderActiveColor = UIColor(named: .green).darker()
        userField?.dividerActiveColor = UIColor(named: .green).darker()
        userField?.isClearIconButtonEnabled = true
        userField?.detailColor = UIColor(named: .red)
        
        passwordField = container.viewWithTag(5) as? TextField
        passwordField?.placeholder = NSLocalizedString("PASSWORD", comment: "")
        passwordField?.font = RobotoFont.regular(with: 13)
        passwordField?.placeholderActiveColor = UIColor(named: .green).darker()
        passwordField?.dividerActiveColor = UIColor(named: .green).darker()
        passwordField?.isClearIconButtonEnabled = true
        passwordField?.detailColor = UIColor(named: .red)
        
        checkbox?.isChecked
            .bind(to: userField!.reactive.isEnabled)
            .dispose(in: bag)
        checkbox?.isChecked
            .bind(to: passwordField!.reactive.isEnabled)
            .dispose(in: bag)
        checkbox?.isChecked.bind(to: self) { me, checked in
            let alpha: CGFloat = checked ? 1.0 : 0.5
            me.userField?.alpha = alpha
            me.passwordField?.alpha = alpha
        }.dispose(in: bag)
        
        self.selectionStyle = .none
    }
}
