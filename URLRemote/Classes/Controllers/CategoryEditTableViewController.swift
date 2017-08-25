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
class CategoryEditTableViewController: UITableViewController {
    let viewModel = CategoryEditViewModel()

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
        close.reactive.tap.bind(to: self) { me, _ in
            me.parent?.dismiss(animated: true, completion: nil)
        }.dispose(in: reactive.bag)
        self.toolbarController?.toolbar.leftViews = [close]
        
        let editButton = IconButton(image: Icon.cm.edit, tintColor: .white)
        editButton.pulseColor = .white
        editButton.reactive.tap.bind(to: self) { me, _ in
            me.displayCategoryNameChange()
        }.dispose(in: reactive.bag)
        
        let deleteButton = IconButton(image: UIImage(named: "delete"), tintColor: .white)
        deleteButton.pulseColor = .white
        deleteButton.reactive.tap.bind(to: self) { me, _ in
            me.presentCategoryRemovalDialog()
        }.dispose(in: reactive.bag)
        
        self.toolbarController?.toolbar.rightViews = [editButton, deleteButton]
        
        self.toolbarController?.toolbar.titleLabel.textColor = .white
        viewModel.categoryName
            .bind(to: toolbarController!.toolbar.reactive.title)
            .dispose(in: reactive.bag)
    }
    
    ///
    func setupTableView() {
        viewModel.entries.bind(to: tableView) { [unowned self] conts, indexPath, tableView in
            let cell = tableView.dequeueReusableCell(withIdentifier: "editCell") as! EntrySettingsTableViewCell
            let entry = conts[indexPath.row]
            cell.layoutSubviews()
            cell.label?.text = entry.name
            cell.showsReorderControl = true
            
            cell.button?.reactive.tap.bind(to: self) { me, _ in
                let entryController = me.storyboard?.instantiateViewController(withIdentifier: "entrySetupController") as! EntrySetupViewController
                me.viewModel.categories.bind(to: entryController.viewModel.categories)
                entryController.viewModel.originalCategoryIndex.value = me.viewModel.categories.index(of: me.viewModel.categoryName.value)!
                entryController.viewModel.setup(with: entry)
                
                me.presentEmbedded(viewController: entryController, barTintColor: UIColor(named: .green))
            }.dispose(in: cell.reactive.bag)
            
            return cell
        }.dispose(in: reactive.bag)
        
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
            handler: { [unowned self] _ in
                if let textFields = categoryDialog.textFields, let textField = textFields[safe: 0], let text = textField.text, text != "" {
                    self.viewModel.categoryName.value = text
                }
        }))
        
        categoryDialog.addTextField { [unowned self] textField in
            textField.placeholder = NSLocalizedString("CHANGE_CATEGORY_NAME_PLACEHOLDER", comment: "")
            textField.text = self.viewModel.categoryName.value
            _ = textField.reactive.text.map {
                guard let text = $0 else { return false }
                return text != ""
                }.observeNext { next in
                    categoryDialog.actions[safe: 1]?.isEnabled = next
            }.dispose(in: categoryDialog.reactive.bag)
        }
        
        self.present(categoryDialog, animated: true, completion: nil)
    }
    
    // MARK: - Category removal
    
    func presentCategoryRemovalDialog() {
        let categoryDialog = UIAlertController(
            title: NSLocalizedString("DELETE_CATEGORY", comment: ""),
            message: NSLocalizedString("DELETE_CATEGORY_DESC", comment: ""),
            preferredStyle: .alert)
        
        categoryDialog.addAction(UIAlertAction(
            title: NSLocalizedString("CANCEL", comment: ""),
            style: .default,
            handler: nil))
        
        categoryDialog.addAction(UIAlertAction(
            title: NSLocalizedString("DELETE", comment: ""),
            style: .destructive,
            handler: { [unowned self] _ in
                self.viewModel.removeCategory()
                self.parent?.dismiss(animated: true, completion: nil)
        }))
        
        self.present(categoryDialog, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeItem(index: indexPath.row)
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        viewModel.moveItem(from: fromIndexPath.row, to: to.row)
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}