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
        _ = close.reactive.tap.observeNext {
            self.parent?.dismiss(animated: true, completion: nil)
        }
        self.toolbarController?.toolbar.leftViews = [close]
        
        let editButton = IconButton(image: Icon.cm.edit, tintColor: .white)
        editButton.pulseColor = .white
        _ = editButton.reactive.tap.observeNext {
            self.displayCategoryNameChange()
        }
        self.toolbarController?.toolbar.rightViews = [editButton]
        
        self.toolbarController?.toolbar.titleLabel.textColor = .white
        viewModel.categoryName.bind(to: self.toolbarController!.toolbar.reactive.bndTitle)
    }
    
    ///
    func setupTableView() {
        self.viewModel.entries.bind(to: self.tableView) { conts, indexPath, tableView in
            let cell = tableView.dequeueReusableCell(withIdentifier: "editCell") as! EntrySettingsTableViewCell
            let entry = conts[indexPath.row]
            cell.layoutSubviews()
            cell.label?.text = entry.name
            cell.showsReorderControl = true
            
            _ = cell.button?.reactive.tap.observeNext {
                let entryController = self.storyboard?.instantiateViewController(withIdentifier: "entrySetupController") as! EntrySetupViewController
                entryController.viewModel.setup(with: entry)
                
                self.presentEmbedded(viewController: entryController, barTintColor: UIColor(named: .green))
            }
            
            return cell
        }
        
        self.tableView.reactive.dataSource.forwardTo = self
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.backgroundColor = UIColor(named: .gray)
        self.tableView.setEditing(true, animated: false)
    }
    
    // MARK: - Category renaming
    
    ///
    func displayCategoryNameChange() {
        let categoryDialog = UIAlertController(
            title: NSLocalizedString("CHANGE_CATEGORY_NAME", comment: ""),
            message: NSLocalizedString("CHANGE_CATEGORY_NAME_DESC", comment: ""),
            preferredStyle: .alert)
        
        categoryDialog.addAction(UIAlertAction(
            title: NSLocalizedString("CANCEL", comment: ""),
            style: .destructive,
            handler: nil))
        
        categoryDialog.addAction(UIAlertAction(
            title: NSLocalizedString("OK", comment: ""),
            style: .default,
            handler: { _ in
                if let textFields = categoryDialog.textFields, let textField = textFields[safe: 0], let text = textField.text, text != "" {
                    self.viewModel.categoryName.value = text
                }
        }))
        
        categoryDialog.addTextField { textField in
            textField.placeholder = NSLocalizedString("CHANGE_CATEGORY_NAME_PLACEHOLDER", comment: "")
            textField.text = self.viewModel.categoryName.value
            _ = textField.reactive.text.map {
                guard let text = $0 else { return false }
                return text != ""
                }.observeNext { next in
                    categoryDialog.actions[safe: 1]?.isEnabled = next
            }
        }
        
        self.present(categoryDialog, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.viewModel.removeItem(index: indexPath.row)
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        self.viewModel.moveItem(from: fromIndexPath.row, to: to.row)
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
