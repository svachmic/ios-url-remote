//
//  EntrySetupViewController.swift
//  URLRemote
//
//  Created by Michal Švácha on 04/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Bond
import Material
import ReactiveKit

///
class EntrySetupViewController: UITableViewController {
    let viewModel = EntrySetupViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor(named: .gray)
        
        self.setupBar()
        self.setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Setup
    
    ///
    func setupBar() {
        let cancel = FlatButton(title: NSLocalizedString("CANCEL", comment: ""))
        cancel.titleColor = .white
        cancel.pulseColor = .white
        cancel.titleLabel?.font = RobotoFont.bold(with: 15)
        
        cancel.reactive.tap.bind(to: self) { me, _ in
            me.parent?.dismiss(animated: true, completion: nil)
        }.dispose(in: reactive.bag)
        
        self.toolbarController?.toolbar.leftViews = [cancel]
        
        let done = IconButton(image: Icon.cm.check, tintColor: .white)
        done.pulseColor = .white
        viewModel.isFormComplete
            .bind(to: done.reactive.isEnabled)
            .dispose(in: reactive.bag)
        
        done.reactive.tap.bind(to: self) { me, _ in
            let entry = me.viewModel.toEntry()
            let entryDto = EntryDto(entry: entry, originalCategoryIndex: me.viewModel.originalCategoryIndex.value, categoryIndex: me.viewModel.selectedCategoryIndex.value)
            NotificationCenter.default.post(
                name: DataSourceNotifications.createdEntry.name,
                object: entryDto)
            
            me.parent?.dismiss(animated: true, completion: nil)
        }.dispose(in: reactive.bag)
        self.toolbarController?.toolbar.rightViews = [done]
        
        self.toolbarController?.toolbar.titleLabel.textColor = .white
        viewModel.name
            .bind(to: toolbarController!.toolbar.reactive.bndTitle)
            .dispose(in: reactive.bag)
    }
    
    ///
    func setupTableView() {
        viewModel.contents.bind(to: tableView) { [unowned self] contents, indexPath, tableView in
            let content = contents[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: content.identifier, for: indexPath)
            cell.backgroundColor = .clear
            
            switch content.identifier {
            case "designCell":
                if let designCell = cell as? DesignEntryTableViewCell {
                    self.setupDesignCell(cell: designCell)
                }
                break
            case "categoryCell":
                if let categoryCell = cell as? GenericButtonTableViewCell {
                    self.setupCategoryCell(cell: categoryCell)
                }
                break
            case "typeCell":
                if let typeCell = cell as? GenericButtonTableViewCell {
                    self.setupTypeCell(cell: typeCell)
                }
                break
            case "actionCell":
                if let actionCell = cell as? ActionEntryTableViewCell {
                    self.setupActionCell(cell: actionCell)
                }
                break
            case "criteriaCell":
                if let criteriaCell = cell as? CustomCriteriaTableViewCell {
                    self.setupCustomCriteriaCell(cell: criteriaCell)
                }
                break
            default:
                break
            }
            
            return cell
        }.dispose(in: self.reactive.bag)
    }
    
    // MARK: - Cell setup
    
    ///
    func setupDesignCell(cell: DesignEntryTableViewCell) {
        cell.layoutSubviews()
        
        cell.icon?.reactive.tap.bind(to: self) { me, _ in
            me.presentIconController()
        }.dispose(in: cell.reactive.bag)
        
        viewModel.color
            .map { return UIColor(named: $0) }
            .bind(to: cell.icon!.reactive.backgroundColor)
            .dispose(in: cell.reactive.bag)
        
        viewModel.icon
            .map { UIImage(named: $0) }
            .bind(to: cell) { c, im in
                if let i = im {
                    c.icon?.image = i.withRenderingMode(.alwaysTemplate)
                    c.icon?.imageView?.tintColor = .white
                }
            }.dispose(in: cell.reactive.bag)
        
        viewModel.name
            .bind(to: cell.nameField!.reactive.text)
            .dispose(in: cell.reactive.bag)
        
        cell.nameField?.reactive.text
            .map { $0 ?? ""}
            .bind(to: viewModel.name)
            .dispose(in: cell.reactive.bag)
        
        cell.colorSelector!.setupViews(with: [.green, .yellow, .red])
        cell.colorSelector!.signal
            .bind(to: viewModel.color)
            .dispose(in: cell.reactive.bag)
    }
    
    ///
    func setupCategoryCell(cell: GenericButtonTableViewCell) {
        cell.layoutSubviews()
        viewModel.selectedCategoryIndex
            .map { [unowned self] in self.viewModel.categories[$0] }
            .bind(to: cell.button!.reactive.title)
            .dispose(in: cell.reactive.bag)
        cell.button?.reactive.tap.bind(to: self) { me, _ in
            me.presentCategoryController()
        }.dispose(in: cell.reactive.bag)
    }
    
    ///
    func setupTypeCell(cell: GenericButtonTableViewCell) {
        cell.layoutSubviews()
        viewModel.type
            .map { $0.toString() }
            .bind(to: cell.button!.reactive.title)
            .dispose(in: cell.reactive.bag)
        cell.button?.reactive.tap.bind(to: self) { me, _ in
            me.presentTypeController()
        }.dispose(in: cell.reactive.bag)
    }
    
    ///
    func setupActionCell(cell: ActionEntryTableViewCell) {
        cell.layoutSubviews()
        
        viewModel.url
            .bind(to: cell.urlField!.reactive.text)
            .dispose(in: cell.reactive.bag)
        
        cell.urlField?.reactive.text
            .map { $0 ?? ""}
            .bind(to: viewModel.url)
            .dispose(in: cell.reactive.bag)
        
        viewModel.requiresAuthentication
            .bidirectionalBind(to: cell.checkbox!.isChecked)
            .dispose(in: cell.reactive.bag)
        
        viewModel.user
            .bind(to: cell.userField!.reactive.text)
            .dispose(in: cell.reactive.bag)
        
        cell.userField?.reactive.text
            .map { $0 ?? ""}
            .bind(to: viewModel.user)
            .dispose(in: cell.reactive.bag)
        
        viewModel.password
            .bind(to: cell.passwordField!.reactive.text)
            .dispose(in: cell.reactive.bag)
        
        cell.passwordField?.reactive.text
            .map { $0 ?? ""}
            .bind(to: viewModel.password)
            .dispose(in: cell.reactive.bag)
    }
    
    ///
    func setupCustomCriteriaCell(cell: CustomCriteriaTableViewCell) {
        cell.layoutSubviews()
        
        viewModel.customCriteria
            .bind(to: cell.criteriaField!.reactive.text)
            .dispose(in: cell.reactive.bag)
        
        cell.criteriaField?.reactive.text
            .map { $0 ?? ""}
            .bind(to: viewModel.customCriteria)
            .dispose(in: cell.reactive.bag)
        
        cell.infoButton?.reactive.tap.bind(to: self) { me, _ in
            me.presentSimpleAlertDialog(
                header: NSLocalizedString("CUSTOM_CRITERIA", comment: ""),
                message: NSLocalizedString("CUSTOM_CRITERIA_DESC", comment: ""))
        }.dispose(in: cell.reactive.bag)
    }
    
    // MARK: - Presentation methods
    
    func presentIconController() {
        let iconController = self.storyboard?.instantiateViewController(withIdentifier: "iconController") as! IconCollectionViewController
        iconController.iconColor = UIColor(named: viewModel.color.value)
        iconController.viewModel.setInitial(value: viewModel.icon.value)
        self.presentEmbedded(viewController: iconController, barTintColor: UIColor(named: .green))
    }
    
    func presentCategoryController() {
        let categoryController = self.storyboard?.instantiateViewController(withIdentifier: "categoryTableController") as! CategoryTableViewController
        viewModel.categories
            .bind(to: categoryController.viewModel.contents)
            .dispose(in: categoryController.reactive.bag)
        categoryController.viewModel.signal
            .bind(to: viewModel.selectedCategoryIndex)
            .dispose(in: categoryController.reactive.bag)
        
        self.presentEmbedded(viewController: categoryController, barTintColor: UIColor(named: .green))
    }
    
    func presentTypeController() {
        let typeController = self.storyboard?.instantiateViewController(withIdentifier: "typeController") as! TypeTableViewController
        typeController.viewModel
            .signal.bind(to: viewModel.type)
            .dispose(in: typeController.reactive.bag)
        
        self.presentEmbedded(viewController: typeController, barTintColor: UIColor(named: .green))
    }
    
    // MARK: - UITableView delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.contents[indexPath.row].height
    }
}
