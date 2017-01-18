//
//  EditTableViewController.swift
//  URLRemote
//
//  Created by Michal Švácha on 17/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Bond
import Material

///
class SettingsTableViewController: UITableViewController {
    let viewModel = SettingsViewModel()

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
        let close = FlatButton(title: NSLocalizedString("CLOSE", comment: ""))
        close.titleColor = .white
        close.pulseColor = .white
        close.titleLabel?.font = RobotoFont.bold(with: 15)
        _ = close.bnd_tap.observeNext {
            self.parent?.dismiss(animated: true, completion: nil)
        }
        self.toolbarController?.toolbar.leftViews = [close]
        
        self.toolbarController?.toolbar.titleLabel.textColor = .white
        self.toolbarController?.toolbar.title = NSLocalizedString("SETTINGS", comment: "")
    }
    
    ///
    func setupTableView() {
        self.viewModel.entries.bind(to: self.tableView) { conts, indexPath, tableView in
            let cell = tableView.dequeueReusableCell(withIdentifier: "editCell") as! EntrySettingsTableViewCell
            let entry = conts[indexPath.row]
            cell.layoutSubviews()
            cell.label?.text = entry.name
            cell.showsReorderControl = true
            
            _ = cell.button?.bnd_tap.observeNext {
                let entryController = self.storyboard?.instantiateViewController(withIdentifier: "entrySetupController") as! EntrySetupViewController
                entryController.viewModel.setup(with: entry)
                
                let toolbarController = ToolbarController(rootViewController: entryController)
                toolbarController.statusBarStyle = .lightContent
                toolbarController.statusBar.backgroundColor = UIColor(named: .green).darker()
                toolbarController.toolbar.backgroundColor = UIColor(named: .green)
                self.toolbarController?.present(toolbarController, animated: true, completion: nil)
            }
            
            return cell
        }
        
        self.tableView.bnd_dataSource.forwardTo = self
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.backgroundColor = UIColor(named: .gray)
        self.tableView.setEditing(true, animated: false)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.viewModel.entries.remove(at: indexPath.row)
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        self.viewModel.moveItem(from: fromIndexPath.row, to: to.row)
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
