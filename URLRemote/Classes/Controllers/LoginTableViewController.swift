//
//  LoginTableViewController.swift
//  URLRemote
//
//  Created by Michal Švácha on 23/11/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit
import Material

///
class LoginTableViewController: UITableViewController {
    let viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(named: .gray)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.alwaysBounceVertical = false
        self.tableView.alwaysBounceHorizontal = false
        self.tableView.separatorStyle = .none
        
        self.setupNotificationHandler()
        self.setupTableView()
    }
    
    /// Sets up notification handlers for sign in/up actions.
    func setupNotificationHandler() {
        NotificationCenter.default.bnd_notification(name: NSNotification.Name(rawValue: "FAILED_SIGN_UP"))
            .observeNext { self.handle(notification: $0) }
            .disposeIn(bnd_bag)
        
        NotificationCenter.default.bnd_notification(name: NSNotification.Name(rawValue: "FAILED_SIGN_IN"))
            .observeNext { self.handle(notification: $0) }
            .disposeIn(bnd_bag)
    }
    
    /// Handles a notification simply by displaying an alert dialog with an error message describing the problem that has occurred.
    ///
    /// - Parameter notification: Notification to be handled.
    func handle(notification: Notification) {
        var message = NSLocalizedString("GENERIC_ERROR", comment: "")
        if let body = notification.object as? Error {
            message = body.localizedDescription
        }
        
        self.presentSimpleAlertDialog(
            header: NSLocalizedString(notification.name.rawValue, comment: ""),
            message: message)
    }
    
    ///
    func setupTableView() {
        self.viewModel.contents.bind(to: self.tableView) { conts, indexPath, tableView in
            let content = conts[indexPath.row]
            let identifier = content.identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            switch identifier {
            case "emailCell", "passwordCell", "passwordAgainCell":
                let textField = cell.viewWithTag(1) as! TextField
                textField.placeholder = content.text
                textField.font = RobotoFont.regular(with: 15)
                textField.leftViewMode = .always
                textField.placeholderActiveColor = UIColor(named: .greener).darker()
                textField.dividerActiveColor = UIColor(named: .greener).darker()
                textField.leftViewActiveColor = UIColor(named: .greener).darker()
                textField.isClearIconButtonEnabled = true
                textField.detailColor = UIColor(named: .red)
                let leftView = UIImageView()
                
                if identifier == "emailCell" {
                    leftView.image = Icon.email
                    self.bindEmailCell(textField: textField)
                } else if identifier == "passwordCell" {
                    leftView.image = Icon.visibility
                    self.bindPasswordCell(index: 0, textField: textField)
                } else if identifier == "passwordAgainCell" {
                    leftView.image = Icon.visibility
                    self.bindPasswordCell(index: 1, textField: textField)
                }
                
                textField.leftView = leftView
                
                break
            case "signUpCell":
                let button = cell.viewWithTag(1) as! RaisedButton
                button.titleLabel?.font = RobotoFont.bold(with: 17)
                button.title = content.text
                button.backgroundColor = UIColor(named: .red)
                
                self.bindSignButton(state: .signIn, button: button)
                break
            case "signInCell":
                let button = cell.viewWithTag(1) as! RaisedButton
                button.titleLabel?.font = RobotoFont.bold(with: 17)
                button.title = content.text
                button.backgroundColor = UIColor(named: .yellow)
                
                self.bindSignButton(state: .signUp, button: button)
                break
            case "textCell":
                let label = cell.viewWithTag(1) as! UILabel
                label.text = content.text
                break
            default:
                break
            }
            
            return cell
        }
    }
    
    // MARK: - Bindings
    
    ///
    func bindEmailCell(textField: TextField) {
        textField.bnd_text.bind(to: self.viewModel.email)
        
        _ = textField.bnd_text.map { text -> String in
            if let text = text, !text.isValidEmail(), text != "" {
                return NSLocalizedString("INVALID_EMAIL", comment: "")
            } else {
                return ""
            }
        }.bind(to: textField.bndDetail)
    }
    
    ///
    func bindPasswordCell(index: Int, textField: TextField) {
        if index == 0 {
            // first password field during both sign in/up
            
            textField.bnd_text.bind(to: self.viewModel.password)
            
            textField.bnd_text.skip(first: 1).map { text in
                if let text = text, (text.characters.count < 6 && text.characters.count != 0) {
                    return NSLocalizedString("INVALID_PASSWORD_LENGTH", comment: "")
                }
                return ""
            }.bind(to: textField.bndDetail)
        } else {
            // second password field during sign up
            
            textField.bnd_text.bind(to: self.viewModel.passwordAgain)
            
            _ = combineLatest(self.viewModel.password, self.viewModel.passwordAgain)
                .map { pass, pass2 in
                    if let p = pass, let p2 = pass2, p != p2 {
                        return NSLocalizedString("INVALID_PASSWORD", comment: "")
                    } else {
                        return ""
                    }
                }.bind(to: textField.bndDetail)
        }
    }
    
    ///
    func bindSignButton(state: LoginState, button: RaisedButton) {
        _ = button.bnd_tap.observeNext {
            if self.viewModel.state == state {
                self.viewModel.transform()
            } else {
                self.viewModel.signUp()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    ///
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewModel.contents[indexPath.row].height
    }
}
