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
        _ = cancel.bnd_tap.observeNext {
            self.parent?.dismiss(animated: true, completion: nil)
        }
        self.toolbarController?.toolbar.leftViews = [cancel]
        
        let done = IconButton(image: Icon.cm.check, tintColor: .white)
        done.pulseColor = .white
        self.viewModel.isFormComplete.bind(to: done.bnd_isEnabled)
        _ = done.bnd_tap.observeNext {
            let entry = self.viewModel.toEntry()
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: "CREATED_ENTRY"),
                object: entry)
            
            self.parent?.dismiss(animated: true, completion: nil)
        }
        self.toolbarController?.toolbar.rightViews = [done]
        
        self.toolbarController?.toolbar.titleLabel.textColor = .white
        self.viewModel.name.bind(to: self.toolbarController!.toolbar.bndTitle)
    }
    
    ///
    func setupTableView() {
        self.viewModel.contents.bind(to: tableView) { contents, indexPath, tableView in
            let content = contents[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: content.identifier, for: indexPath)
            cell.backgroundColor = .clear
            
            switch content.identifier {
            case "designCell":
                if let designCell = cell as? DesignEntryTableViewCell {
                    self.setupDesignCell(cell: designCell)
                }
                break
            case "typeCell":
                if let typeCell = cell as? TypeEntryTableViewCell {
                    self.setupTypeCell(cell: typeCell)
                }
                break
            case "actionCell":
                if let actionCell = cell as? ActionEntryTableViewCell {
                    self.setupActionCell(cell: actionCell)
                }
                break
            default:
                break
            }
            
            return cell
        }
    }
    
    // MARK: - Cell setup
    
    ///
    func setupDesignCell(cell: DesignEntryTableViewCell) {
        cell.layoutSubviews()
        _ = cell.icon?.bnd_tap.observeNext {
            self.presentIconController()
        }
        self.viewModel.color
            .map { return UIColor(named: $0) }
            .bind(to: cell.icon!.bnd_backgroundColor)
        
        _ = self.viewModel.icon
            .map { UIImage(named: $0) }
            .observeNext {
                if let image = $0 {
                    cell.icon?.image = image.withRenderingMode(.alwaysTemplate)
                    cell.icon?.imageView?.tintColor = .white
                }
        }
        
        _ = self.viewModel.name.bidirectionalBind(
            to: cell.nameField!.bnd_text.bidirectionalMap(
                to: { $0 ?? "" },
                from: { $0 }))
        
        cell.colorSelector!.setupViews(with: [.green, .yellow, .red])
        cell.colorSelector!.signal.bind(to: self.viewModel.color)
    }
    
    ///
    func setupTypeCell(cell: TypeEntryTableViewCell) {
        cell.layoutSubviews()
        self.viewModel.type
            .map { $0.toString() }
            .bind(to: cell.button!.bnd_title)
        _ = cell.button?.bnd_tap.observeNext {
            self.presentTypeController()
        }
    }
    
    ///
    func setupActionCell(cell: ActionEntryTableViewCell) {
        cell.layoutSubviews()
        
        _ = self.viewModel.url.bidirectionalBind(
            to: cell.urlField!.bnd_text.bidirectionalMap(
                to: { $0 ?? "" },
                from: { $0 }))
        
        _ = self.viewModel.requiresAuthentication.bidirectionalBind(to: cell.checkbox!.isChecked)
        
        _ = self.viewModel.user.bidirectionalBind(
            to: cell.userField!.bnd_text.bidirectionalMap(
                to: { $0 ?? "" },
                from: { $0 }))
        
        _ = self.viewModel.password.bidirectionalBind(
            to: cell.passwordField!.bnd_text.bidirectionalMap(
                to: { $0 ?? "" },
                from: { $0 }))
    }
    
    func presentIconController() {
        let iconController = self.storyboard?.instantiateViewController(withIdentifier: "iconController") as! IconCollectionViewController
        iconController.iconColor = UIColor(named: self.viewModel.color.value)
        iconController.viewModel.setInitial(value: self.viewModel.icon.value)
        self.presentEmbedded(viewController: iconController, barTintColor: UIColor(named: .green))
    }
    
    func presentTypeController() {
        let typeController = self.storyboard?.instantiateViewController(withIdentifier: "typeController") as! TypeTableViewController
        typeController.viewModel.signal.bind(to: self.viewModel.type)
        self.presentEmbedded(viewController: typeController, barTintColor: UIColor(named: .green))
    }
    
    // MARK: - UITableView delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewModel.contents[indexPath.row].height
    }
}
