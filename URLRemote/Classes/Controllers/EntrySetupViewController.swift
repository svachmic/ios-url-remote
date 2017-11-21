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

///
class EntrySetupViewController: UITableViewController, PersistenceStackController, Dismissable {
    var stack: PersistenceStack! {
        didSet {
            viewModel = EntrySetupViewModel(dataSource: stack.dataSource!)
        }
    }
    var viewModel: EntrySetupViewModel!

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
        setupDismissButton(with: .cancel)
        
        let done = MaterialFactory.genericIconButton(image: Icon.cm.check)
        viewModel.isFormComplete
            .bind(to: done.reactive.isEnabled)
            .dispose(in: bag)
        done.reactive.tap.bind(to: self) { me, _ in
            me.viewModel.saveData()
            me.parent?.dismiss(animated: true, completion: nil)
        }.dispose(in: bag)
        self.toolbarController?.toolbar.rightViews = [done]
        
        self.toolbarController?.toolbar.titleLabel.textColor = .white
        viewModel.name
            .bind(to: toolbarController!.toolbar.reactive.title)
            .dispose(in: bag)
    }
    
    ///
    func setupTableView() {
        viewModel.contents.bind(to: tableView) { [unowned self] contents, indexPath, tableView in
            let content = contents[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: content.identifier, for: indexPath)
            cell.bag.dispose()
            cell.backgroundColor = .clear
            self.setupBindings(for: cell, with: content.identifier, and: content.type)
            
            return cell
        }.dispose(in: bag)
    }
    
    // MARK: - Cell setup
    
    ///
    func setupBindings(for cell: UITableViewCell, with identifier: String, and type: String) {
        switch (identifier, cell) {
        case (Constants.TableViewCell.design, let designCell as DesignEntryTableViewCell):
            setupDesignCell(cell: designCell)
        case (Constants.TableViewCell.genericButton, let categoryCell as GenericButtonTableViewCell) where type == "category":
            setupCategoryCell(cell: categoryCell)
        case (Constants.TableViewCell.genericButton, let typeCell as GenericButtonTableViewCell) where type != "category":
            setupTypeCell(cell: typeCell)
        case (Constants.TableViewCell.action, let actionCell as ActionEntryTableViewCell):
            setupActionCell(cell: actionCell)
        case (Constants.TableViewCell.criteria, let criteriaCell as CustomCriteriaTableViewCell):
            setupCustomCriteriaCell(cell: criteriaCell)
        default:
            break
        }
    }
    
    ///
    func setupDesignCell(cell: DesignEntryTableViewCell) {
        cell.iconButton.reactive.tap.bind(to: self) { me, _ in
            me.presentIconController()
        }.dispose(in: cell.bag)
        
        viewModel.color
            .map { return UIColor(named: $0) }
            .bind(to: cell.iconButton.reactive.backgroundColor)
            .dispose(in: cell.bag)
        
        viewModel.icon
            .map { UIImage(named: $0) }
            .bind(to: cell.reactive.iconImage)
            .dispose(in: cell.bag)
        
        viewModel.name
            .bind(to: cell.nameField.reactive.text)
            .dispose(in: cell.bag)
        
        cell.nameField.reactive.text
            .map { $0 ?? ""}
            .bind(to: viewModel.name)
            .dispose(in: cell.bag)
        
        cell.colorSelector.setupViews(with: [.green, .yellow, .red])
        cell.colorSelector.signal
            .bind(to: viewModel.color)
            .dispose(in: cell.bag)
    }
    
    ///
    func setupCategoryCell(cell: GenericButtonTableViewCell) {
        viewModel.selectedCategoryIndex
            .map { [unowned self] in self.viewModel.categories[$0].name }
            .bind(to: cell.button.reactive.title)
            .dispose(in: cell.bag)
        cell.button.reactive.tap.bind(to: self) { me, _ in
            me.presentCategoryController()
        }.dispose(in: cell.bag)
    }
    
    ///
    func setupTypeCell(cell: GenericButtonTableViewCell) {
        viewModel.type
            .map { $0.toString() }
            .bind(to: cell.button.reactive.title)
            .dispose(in: cell.bag)
        cell.button.reactive.tap.bind(to: self) { me, _ in
            me.presentTypeController()
        }.dispose(in: cell.bag)
    }
    
    ///
    func setupActionCell(cell: ActionEntryTableViewCell) {
        viewModel.url
            .bind(to: cell.urlField.reactive.text)
            .dispose(in: cell.bag)
        
        cell.urlField.reactive.text
            .map { $0 ?? ""}
            .bind(to: viewModel.url)
            .dispose(in: cell.bag)
        
        cell.bindCheckbox()
        viewModel.requiresAuthentication
            .bidirectionalBind(to: cell.checkboxButton.isChecked)
            .dispose(in: cell.bag)
        
        viewModel.user
            .bind(to: cell.usernameField.reactive.text)
            .dispose(in: cell.bag)
        
        cell.usernameField.reactive.text
            .map { $0 ?? ""}
            .bind(to: viewModel.user)
            .dispose(in: cell.bag)
        
        viewModel.password
            .bind(to: cell.passwordField.reactive.text)
            .dispose(in: cell.bag)
        
        cell.passwordField.reactive.text
            .map { $0 ?? ""}
            .bind(to: viewModel.password)
            .dispose(in: cell.bag)
    }
    
    ///
    func setupCustomCriteriaCell(cell: CustomCriteriaTableViewCell) {
        viewModel.customCriteria
            .bind(to: cell.criteriaField.reactive.text)
            .dispose(in: cell.bag)
        
        cell.criteriaField.reactive.text
            .map { $0 ?? ""}
            .bind(to: viewModel.customCriteria)
            .dispose(in: cell.bag)
        
        cell.infoButton.reactive.tap.bind(to: self) { me, _ in
            me.presentSimpleAlertDialog(
                header: NSLocalizedString("CUSTOM_CRITERIA", comment: ""),
                message: NSLocalizedString("CUSTOM_CRITERIA_DESC", comment: ""))
        }.dispose(in: cell.bag)
    }
    
    // MARK: - Presentation methods
    
    func presentIconController() {
        let iconController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.iconSelection) as! IconCollectionViewController
        iconController.viewModel.iconColor = UIColor(named: viewModel.color.value)
        iconController.viewModel.setInitial(value: viewModel.icon.value)
        iconController.viewModel.signal.bind(to: viewModel.icon)
        self.presentEmbedded(viewController: iconController, barTintColor: UIColor(named: .green))
    }
    
    func presentCategoryController() {
        let categoryController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.categorySelection) as! CategoryTableViewController
        viewModel.categories
            .bind(to: categoryController.viewModel.contents)
            .dispose(in: categoryController.bag)
        categoryController.viewModel.initialSelection.value = viewModel.selectedCategoryIndex.value
        categoryController.viewModel.signal
            .bind(to: viewModel.selectedCategoryIndex)
            .dispose(in: categoryController.bag)
        self.presentEmbedded(viewController: categoryController, barTintColor: UIColor(named: .green))
    }
    
    func presentTypeController() {
        let typeController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.typeSelection) as! TypeTableViewController
        typeController.viewModel
            .signal.bind(to: viewModel.type)
            .dispose(in: typeController.bag)
        self.presentEmbedded(viewController: typeController, barTintColor: UIColor(named: .green))
    }
    
    // MARK: - UITableView delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.contents[indexPath.row].height
    }
}
