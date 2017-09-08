//
//  CategoryTableViewController.swift
//  URLRemote
//
//  Created by Michal Švácha on 14/07/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit
import Material

/// View controller taking care of category selection.
class CategoryTableViewController: UITableViewController {
    let viewModel = CategoryTableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupBar()
        self.setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - View setup
    
    /// Sets up all the buttons in the toolbar.
    func setupBar() {
        let cancel = FlatButton(title: NSLocalizedString("CANCEL", comment: ""))
        cancel.titleColor = .white
        cancel.pulseColor = .white
        cancel.titleLabel?.font = RobotoFont.bold(with: 15)
        cancel.reactive.tap.bind(to: self) { me, _ in
            me.parent?.dismiss(animated: true, completion: nil)
        }.dispose(in: bag)
        self.toolbarController?.toolbar.leftViews = [cancel]
        
        let done = IconButton(image: Icon.cm.check, tintColor: .white)
        done.pulseColor = .white
        combineLatest(viewModel.initialSelection, viewModel.userSelection)
            .map { return $0 != $1 }
            .bind(to: done.reactive.isEnabled)
            .dispose(in: bag)
        done.reactive.tap.bind(to: self) { me, _ in
            me.viewModel.done()
            self.parent?.dismiss(animated: true, completion: nil)
        }.dispose(in: bag)
        self.toolbarController?.toolbar.rightViews = [done]
        
        self.toolbarController?.toolbar.titleLabel.textColor = .white
        self.toolbarController?.toolbar.title = NSLocalizedString("SELECT_CATEGORY", comment: "")
    }
    
    /// Sets up the bindings of the table view.
    func setupTableView() {
        combineLatest(viewModel.userSelection, viewModel.contents).map { $1 }.bind(to: tableView) { [unowned self] conts, indexPath, tableView in
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCell.categorySelection) as! CategorySelectionTableViewCell
            let category = conts[indexPath.row]
            let selected = indexPath.row == self.viewModel.userSelection.value
            cell.setup(with: category, selected: selected)
            return cell
        }.dispose(in: bag)
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.backgroundColor = UIColor(named: .gray)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selected(indexPath.row)
    }
}
