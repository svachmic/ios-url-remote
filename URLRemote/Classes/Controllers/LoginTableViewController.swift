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

/// Controller used for logging user in. It is presented when the there is no user logged in.
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Sets up notification handlers for sign in/up actions.
    func setupNotificationHandler() {
        NotificationCenter.default.reactive.notification(name: NSNotification.Name(rawValue: "FAILED_SIGN_UP"))
            .observeNext { self.handle(notification: $0) }
            .dispose(in: reactive.bag)
        
        NotificationCenter.default.reactive.notification(name: NSNotification.Name(rawValue: "FAILED_SIGN_IN"))
            .observeNext { self.handle(notification: $0) }
            .dispose(in: reactive.bag)
        
        NotificationCenter.default.reactive.notification(name: NSNotification.Name(rawValue: "SUCCESS_SIGN_IN"))
            .observeNext { _ in self.parent?.dismiss(animated: true) }
            .dispose(in: reactive.bag)
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
    
    /// Sets up the full table view by hooking in up to the view-model.
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
                textField.placeholderActiveColor = UIColor(named: .green).darker()
                textField.dividerActiveColor = UIColor(named: .green).darker()
                textField.leftViewActiveColor = UIColor(named: .green).darker()
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
    
    /// Binds the e-mail TextField to the view-model. Also sets up binding for detail label of the TextField to display when the e-mail is invalid.
    ///
    /// - Parameter textField: TextField object to be bound.
    func bindEmailCell(textField: TextField) {
        textField.reactive.text.bind(to: self.viewModel.email)
        
        _ = textField.reactive.text.map { text -> String in
            if let text = text, !text.isValidEmail(), text != "" {
                return NSLocalizedString("INVALID_EMAIL", comment: "")
            }
            return ""
        }.bind(to: textField.reactive.bndDetail)
    }
    
    /// Binds the password and repeated password TextFields to the view-model.
    /// - First TextField has length validation.
    /// - Second TextField has similarity validation (to the first one entered).
    ///
    /// - Parameter index: Integer indicating which TextField is to be handled. 0 is for the first, 1 is for the second.
    /// - Parameter textField: TextField object to be bound.
    func bindPasswordCell(index: Int, textField: TextField) {
        if index == 0 {
            // first password field during both sign in/up
            textField.reactive.text.bind(to: self.viewModel.password)
            
            textField.reactive.text.skip(first: 1).map { text in
                if let text = text, (text.characters.count < 6 && text.characters.count != 0) {
                    return NSLocalizedString("INVALID_PASSWORD_LENGTH", comment: "")
                }
                return ""
            }.bind(to: textField.reactive.bndDetail)
        } else {
            // second password field during sign up
            textField.reactive.text.bind(to: self.viewModel.passwordAgain)
            
            _ = combineLatest(self.viewModel.password, self.viewModel.passwordAgain)
                .map { password, repeated in
                    if let pwd = password, let rep = repeated, pwd != rep {
                        return NSLocalizedString("INVALID_PASSWORD", comment: "")
                    }
                    return ""
                }.bind(to: textField.reactive.bndDetail)
        }
    }
    
    /// Binds the sign-action button to the desired activity. It is used for both "Sign In" and "Sign Up" buttons, because their actions are the same (just reversed).
    /// - "Sign In" transforms when state is .signUp.
    /// - "Sign Up" transforms when state is .signIn.
    ///
    /// - Parameter state: State to be compared for transformation.
    /// - Parameter button: RaisedButton object to be bound.
    func bindSignButton(state: LoginState, button: RaisedButton) {
        _ = button.reactive.tap.observeNext {
            self.view.endEditing(true)
            
            if self.viewModel.state == state {
                self.viewModel.transform()
            } else {
                if state == .signIn {
                    self.viewModel.signUp()
                } else {
                    self.viewModel.signIn()
                }
            }
        }
    }
    
    // MARK: - UITableView delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewModel.contents[indexPath.row].height
    }
}
