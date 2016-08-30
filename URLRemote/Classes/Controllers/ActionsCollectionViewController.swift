//
//  ActionsCollectionViewController.swift
//  URLRemote
//
//  Created by Svacha, Michal on 30/05/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import UIKit

private let reuseIdentifier = "actionCell"

class ActionsCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.alwaysBounceVertical = true
        self.collectionView!.backgroundColor = UIColor(named: .UltraLightGray)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        cell.contentView.layer.cornerRadius = cell.frame.width / 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clearColor().CGColor
        cell.contentView.layer.masksToBounds = true
        
        cell.contentView.setCustomGradient(CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint(x: 1.0, y: 1.0), bounds: view.bounds, colors: [UIColor(named: .GradientBackgroundStart).CGColor, UIColor(named: .GradientBackgroundEnd).CGColor])
        
        cell.layer.shadowColor = UIColor.grayColor().CGColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        
        if let label = cell.viewWithTag(5) as? UILabel {
            label.text = String(format: "%@%@", arguments: ["YO", ""])
        } else {
            let height = cell.frame.height * 0.8
            let y = (cell.frame.height - height) * 0.5
            let label = UILabel(frame: CGRect(x: 0, y: y, width: cell.frame.width, height: height))
            label.tag = 5
            
            label.textAlignment = NSTextAlignment.Center
            label.font = UIFont.boldSystemFontOfSize(70)
            label.text = String(format: "%@%@", arguments: ["YO", ""])
            label.textColor = UIColor.whiteColor()
            label.numberOfLines = 1
            label.minimumScaleFactor = 8/label.font.pointSize
            label.adjustsFontSizeToFitWidth = true
            
            cell.addSubview(label)
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    /**
     Adds highlight when cell gets selected.
     
     - parameter collectionView: The collection view object that is notifying you of the highlight change.
     - parameter indexPath: The index path of the cell that was highlighted.
     */
    override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            if cell.viewWithTag(1337) == nil {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
                view.backgroundColor = UIColor(named: .TransparentBlack)
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
    override func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)?.viewWithTag(1337)?.removeFromSuperview()
    }
    
    // MARK: - Flow layout delegate
    
    /**
     Adds margins on the left and on the right.
     
     - parameter collectionView: The collection view object displaying the flow layout.
     - parameter collectionViewLayout: The layout object requesting the information.
     - parameter section: The index number of the section whose insets are needed.
     - returns: The margins to apply to items in the section.
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
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
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        //return CGSize(width: collectionView.frame.width/2.2, height: collectionView.frame.width/2.2)
        
        let screenRect =  UIScreen.mainScreen().bounds
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
