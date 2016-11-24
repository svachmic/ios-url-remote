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
        
        self.viewModel.contents.bind(to: self.tableView) { conts, indexPath, tableView in
            let identifier = conts[indexPath.row].identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            switch identifier {
            case "emailCell", "passwordCell", "passwordAgainCell":
                let textField = cell.viewWithTag(1) as! TextField
                textField.placeholder = conts[indexPath.row].text
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
                    textField.bnd_text.bind(to: self.viewModel.email)
                    
                    _ = textField.bnd_text.map { text -> String in
                        if let text = text, !text.isValidEmail(), text != "" {
                            return NSLocalizedString("INVALID_EMAIL", comment: "")
                        } else {
                            return ""
                        }
                    }.bind(to: textField.bndDetail)
                    
                } else if identifier == "passwordCell" {
                    leftView.image = Icon.visibility
                    textField.bnd_text.bind(to: self.viewModel.password)
                } else if identifier == "passwordAgainCell" {
                    leftView.image = Icon.visibility
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
                
                textField.leftView = leftView
                
                break
            case "signUpCell":
                let button = cell.viewWithTag(1) as! RaisedButton
                button.titleLabel?.font = RobotoFont.bold(with: 17)
                button.title = conts[indexPath.row].text
                button.backgroundColor = UIColor(named: .red)
                
                _ = button.bnd_tap.observeNext {
                    if self.viewModel.state == .signIn {
                        self.viewModel.transform()
                    } else {
                        print("SIGN UP!")
                    }
                }
                
                break
            case "signInCell":
                let button = cell.viewWithTag(1) as! RaisedButton
                button.titleLabel?.font = RobotoFont.bold(with: 17)
                button.title = conts[indexPath.row].text
                button.backgroundColor = UIColor(named: .yellow)
                
                _ = button.bnd_tap.observeNext {
                    if self.viewModel.state == .signUp {
                        self.viewModel.transform()
                    } else {
                        print("SIGN IN!")
                    }
                }
                break
            case "textCell":
                let label = cell.viewWithTag(1) as! UILabel
                label.text = conts[indexPath.row].text
                break
            default:
                break
            }
            
            return cell
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
