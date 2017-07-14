//
//  CategoryTableViewController.swift
//  URLRemote
//
//  Created by Michal Švácha on 14/07/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Bond
import Material

///
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
        
        self.toolbarController?.toolbar.titleLabel.textColor = .white
        self.toolbarController?.toolbar.title = NSLocalizedString("SELECT_CATEGORY", comment: "")
    }
    
    ///
    func setupTableView() {
        viewModel.contents.bind(to: tableView) { conts, indexPath, tableView in
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")!
            cell.backgroundColor = .clear
            cell.textLabel?.font = RobotoFont.medium(with: 16)
            cell.textLabel?.textColor = .gray
            cell.textLabel?.text = conts[indexPath.row]
            return cell
        }.dispose(in: reactive.bag)
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.backgroundColor = UIColor(named: .gray)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selected(indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
}
