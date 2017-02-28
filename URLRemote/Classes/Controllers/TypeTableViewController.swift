//
//  TypeTableViewController.swift
//  URLRemote
//
//  Created by Michal Švácha on 13/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Bond
import Material

///
class TypeTableViewController: UITableViewController {
    let viewModel = TypeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupBar()
        self.setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - View setup
    
    ///
    func setupBar() {
        let cancel = FlatButton(title: NSLocalizedString("CANCEL", comment: ""))
        cancel.titleColor = .white
        cancel.pulseColor = .white
        cancel.titleLabel?.font = RobotoFont.bold(with: 15)
        _ = cancel.reactive.tap.observeNext {
            self.parent?.dismiss(animated: true, completion: nil)
        }
        self.toolbarController?.toolbar.leftViews = [cancel]
        
        self.toolbarController?.toolbar.titleLabel.textColor = .white
        self.toolbarController?.toolbar.title = NSLocalizedString("SELECT_TYPE", comment: "")
    }
    
    ///
    func setupTableView() {
        self.viewModel.contents.bind(to: self.tableView) { conts, indexPath, tableView in
            let cell = tableView.dequeueReusableCell(withIdentifier: "typeCell") as! TypeSelectionTableViewCell
            let type = conts[indexPath.row]
            cell.layoutSubviews()
            cell.label?.text = type.toString()
            
            _ = cell.infoButton?.reactive.tap.observeNext {
                self.presentSimpleAlertDialog(
                    header: type.toString(),
                    message: type.description())
            }
            
            return cell
        }
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.backgroundColor = UIColor(named: .gray)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.selected(indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
}
