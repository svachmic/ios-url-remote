//
//  ActionsCollectionViewController.swift
//  URLRemote
//
//  Created by Svacha, Michal on 30/05/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import UIKit
import Material
import Bond
import ReactiveKit

///
class ActionsCollectionViewController: UICollectionViewController {
    var viewModel: ActionsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.alwaysBounceVertical = true
        self.collectionView!.backgroundColor = UIColor(named: .gray)
        
        if let navigationController = self.navigationController as? ApplicationNavigationController {
            navigationController.prepare()
            navigationController.statusBarStyle = .lightContent
            navigationController.navigationBar.barTintColor = UIColor(named: .yellow)
            
            let logout = FlatButton(title: NSLocalizedString("LOGOUT", comment: ""))
            logout.titleColor = .white
            logout.pulseColor = .white
            logout.titleLabel?.font = RobotoFont.bold(with: 15)
            _ = logout.bnd_tap.observeNext {
                self.viewModel.logout()
            }
            self.navigationItem.leftViews = [logout]
            
            let addButton = IconButton(image: Icon.cm.add, tintColor: .white)
            addButton.pulseColor = .white
            _ = addButton.bnd_tap.observeNext {
                self.displayEntrySetup()
            }
            
            let editButton = IconButton(image: Icon.cm.edit, tintColor: .white)
            editButton.pulseColor = .white
            _ = editButton.bnd_tap.observeNext {
                self.displaySettings()
            }
            
            self.navigationItem.rightViews = [editButton, addButton]
            
            self.navigationItem.titleLabel.textColor = .white
            self.navigationItem.detailLabel.textColor = .white
            
            self.navigationItem.title = "URLRemote"
            self.navigationItem.detail = "Making your IoT awesome!"
        }
        
        self.setLoginNotifications()
        
        self.viewModel = ActionsViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - View setup
    
    ///
    func setLoginNotifications() {
        NotificationCenter.default.bnd_notification(name: NSNotification.Name(rawValue: "USER_LOGGED_OUT"))
            .observeNext { _ in self.displayLogin() }
            .dispose(in: bnd_bag)
        
        NotificationCenter.default.bnd_notification(name: NSNotification.Name(rawValue: "USER_LOGGED_IN"))
            .observeNext { _ in self.setupCollectionDataSource() }
            .dispose(in: bnd_bag)
    }
    
    ///
    func setupCollectionDataSource() {
        self.viewModel.dataSource?.entriesSignal().mapToDataSourceEvent().bind(to: self.collectionView!) { (entries: [Entry], indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell in
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "entryCell",
                for: indexPath) as! ActionViewCell
            cell.setUpView()
            cell.bind(with: entries[indexPath.row])
            return cell
        }
    }
    
    /// MARK: - ViewController presentation
    
    ///
    func displayLogin() {
        let loginController = self.storyboard?.instantiateViewController(withIdentifier: "loginController")
        
        self.presentEmbedded(viewController: loginController!, barTintColor: UIColor(named: .green))
    }
    
    func displayEntrySetup() {
        let entryController = self.storyboard?.instantiateViewController(withIdentifier: "entrySetupController")
        
        self.presentEmbedded(viewController: entryController!, barTintColor: UIColor(named: .green))
    }
    
    func displaySettings() {
        let settingsController = self.storyboard?.instantiateViewController(withIdentifier: "editController") as! SettingsTableViewController
        _ = self.viewModel.dataSource?.entriesSignal().first().observeNext { entries in
            settingsController.viewModel.setupEntries(entries: entries)
        }
        _ = settingsController.viewModel.signal.observeNext { entry in
            self.viewModel.dataSource?.write(entry)
        }
        
        _ = settingsController.viewModel.deleteSignal.observeNext { entry in
            self.viewModel.dataSource?.delete(entry)
        }
        
        self.presentEmbedded(viewController: settingsController, barTintColor: UIColor(named: .green))
    }
    
    // MARK: - Flow layout delegate
    
    /// Adds margins on the left and on the right.
    ///
    /// - Parameter collectionView: The collection view object displaying the flow layout.
    /// - Parameter collectionViewLayout: The layout object requesting the information.
    /// - Parameter section: The index number of the section whose insets are needed.
    /// - Returns: The margins to apply to items in the section.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let diff = collectionView.frame.width * (1.0 / 22.0)
        return UIEdgeInsets(top: 8.0, left: diff/2.0, bottom: 0, right: diff/2.0)
    }
    
    /// Separates the cells in pairs.
    ///
    /// - Warning: Should change later on for iPad to display more cells in one row.
    ///
    /// - Parameter collectionView: The collection view object displaying the flow layout.
    /// - Parameter collectionViewLayout: The layout object requesting the information.
    /// - Parameter indexPath: The index path of the item.
    /// - Returns: The width and height of the specified item. Both values must be greater than 0.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        //return CGSize(width: collectionView.frame.width/2.2, height: collectionView.frame.width/2.2)
        
        let screenRect =  UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let cellWidth = screenWidth / 3.5
        let size = CGSize(width: cellWidth, height: cellWidth)
        return size
    }
}
