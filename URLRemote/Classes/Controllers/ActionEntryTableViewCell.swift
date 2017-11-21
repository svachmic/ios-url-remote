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

/// View responsible for displaying the URL that's supposed to be called. Also handles authentication logic (username + password) input.
class ActionEntryTableViewCell: UITableViewCell {
    @IBOutlet weak var urlField: TextField!
    @IBOutlet weak var checkboxButton: CheckboxButton!
    @IBOutlet weak var checkboxLabel: UILabel!
    @IBOutlet weak var usernameField: TextField!
    @IBOutlet weak var passwordField: TextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        urlField.apply(Stylesheet.EntrySetup.textField)
        urlField.placeholder = NSLocalizedString("URL", comment: "")
        
        checkboxButton.tintColor = .gray
        
        checkboxLabel.text = NSLocalizedString("REQUIRES_AUTH", comment: "")
        checkboxLabel.font = RobotoFont.bold(with: 13)
        checkboxLabel.textColor = .gray
        
        usernameField.apply(Stylesheet.EntrySetup.textField)
        usernameField.placeholder = NSLocalizedString("USER", comment: "")
        
        passwordField.apply(Stylesheet.EntrySetup.textField)
        passwordField.placeholder = NSLocalizedString("PASSWORD", comment: "")
        passwordField.isSecureTextEntry = true
        
        self.selectionStyle = .none
    }
    
    /// Binds checkbox's state to visibility of username + password fields.
    func bindCheckbox() {
        checkboxButton.isChecked
            .bind(to: usernameField.reactive.isEnabled)
            .dispose(in: bag)
        checkboxButton.isChecked
            .bind(to: passwordField.reactive.isEnabled)
            .dispose(in: bag)
        checkboxButton.isChecked.bind(to: self) { me, checked in
            let alpha: CGFloat = checked ? 1.0 : 0.5
            me.usernameField.alpha = alpha
            me.passwordField.alpha = alpha
        }.dispose(in: bag)
    }
}
