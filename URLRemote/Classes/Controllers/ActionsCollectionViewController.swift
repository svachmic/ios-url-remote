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

private let reuseIdentifier = "testCell"

class ActionsCollectionViewController: UICollectionViewController {
    var viewModel: ActionsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(ActionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.alwaysBounceVertical = true
        self.collectionView!.backgroundColor = UIColor(named: .gray)
        
        if let navigationController = self.navigationController as? ApplicationNavigationController {
            navigationController.prepare()
            navigationController.statusBarStyle = .lightContent
            navigationController.navigationBar.barTintColor = UIColor(named: .yellow)
            
            let starButton = IconButton(image: Icon.cm.star, tintColor: .white)
            starButton.pulseColor = .white
            self.navigationItem.leftViews = [starButton]
            
            self.navigationItem.titleLabel.textColor = .white
            self.navigationItem.detailLabel.textColor = .white
            
            self.navigationItem.title = "URLRemote"
            self.navigationItem.detail = "Making your IoT awesome!"
        }
        
        NotificationCenter.default.bnd_notification(name: NSNotification.Name(rawValue: "USER_LOGGED_OUT"))
            .observeNext { _ in self.displayLogin() }
            .disposeIn(bnd_bag)
        
        self.viewModel = ActionsViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayLogin() {
        let loginController = self.storyboard?.instantiateViewController(withIdentifier: "loginController")
        let toolbarController = ToolbarController(rootViewController: loginController!)
        toolbarController.statusBarStyle = .lightContent
        toolbarController.statusBar.backgroundColor = UIColor(named: .greener).darker()
        toolbarController.toolbar.backgroundColor = UIColor(named: .greener)
        self.navigationController?.present(toolbarController, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath) as! ActionViewCell
        cell.setUpViews(bounds: view.bounds)
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    /**
     Adds highlight when cell gets selected.
     
     - parameter collectionView: The collection view object that is notifying you of the highlight change.
     - parameter indexPath: The index path of the cell that was highlighted.
     */
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            if cell.viewWithTag(1337) == nil {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
                view.backgroundColor = UIColor(named: .transparentBlack)
                view.tag = 1337
                cell.addSubview(view)
            }
        }
    }
    
    /**
     Removes highlight when cell gets unselected.
     
     The collection view calls this method only in response to user interactions and does not call it if you programmatically change the highlighting on a cell.
     
     - parameter collectionView: The collection view object that is notifying you of the highlight change.
     - parameter indexPath: The index path of the cell that had its highlight removed.
     */
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.viewWithTag(1337)?.removeFromSuperview()
    }
    
    // MARK: - Flow layout delegate
    
    /**
     Adds margins on the left and on the right.
     
     - parameter collectionView: The collection view object displaying the flow layout.
     - parameter collectionViewLayout: The layout object requesting the information.
     - parameter section: The index number of the section whose insets are needed.
     - returns: The margins to apply to items in the section.
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let diff = collectionView.frame.width * (1.0 / 22.0)
        return UIEdgeInsets(top: 8.0, left: diff/2.0, bottom: 0, right: diff/2.0)
    }
    
    /**
     Separates the cells in pairs.
     
     - warning: Should change later on for iPad to display more cells in one row.
     
     - parameter collectionView: The collection view object displaying the flow layout.
     - parameter collectionViewLayout: The layout object requesting the information.
     - parameter indexPath: The index path of the item.
     - returns: The width and height of the specified item. Both values must be greater than 0.
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        //return CGSize(width: collectionView.frame.width/2.2, height: collectionView.frame.width/2.2)
        
        let screenRect =  UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let cellWidth = screenWidth / 3.5
        let size = CGSize(width: cellWidth, height: cellWidth)
        return size
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
}
