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
        cell.contentView.layer.borderWidth = 1.0;
        cell.contentView.layer.borderColor = UIColor.clearColor().CGColor;
        cell.contentView.layer.masksToBounds = true;
        
        cell.contentView.setCustomGradient(CGPointMake(0.0, 0.0), endPoint: CGPointMake(1.0, 1.0), bounds: view.bounds, colors: [UIColor(named: .GradientBackgroundStart).CGColor, UIColor(named: .GradientBackgroundEnd).CGColor])
        
        cell.layer.shadowColor = UIColor.grayColor().CGColor
        cell.layer.shadowOffset = CGSizeMake(0, 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        
        if let label = cell.viewWithTag(5) as? UILabel {
            label.text = String(format: "%@%@", arguments: ["YO", ""])
        } else {
            let height = cell.frame.height * 0.8
            let y = (cell.frame.height - height) * 0.5
            let label = UILabel(frame: CGRectMake(0, y, cell.frame.width, height))
            label.tag = 5
            
            label.textAlignment = NSTextAlignment.Center
            label.font = UIFont.boldSystemFontOfSize(70)
            label.text = String(format: "%@%@", arguments: ["YO", ""])
            label.textColor = UIColor.whiteColor()
            label.numberOfLines = 1
            label.minimumScaleFactor = 8/label.font.pointSize;
            label.adjustsFontSizeToFitWidth = true
            
            cell.addSubview(label)
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    /**
     Adds margins on the left and on the right.
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let diff = collectionView.frame.width * (1.0 / 22.0)
        return UIEdgeInsetsMake(8.0, diff/2.0, 0, diff/2.0)
    }
    
    /**
     Adds highlight when cell gets selected.
     */
    override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            if cell.viewWithTag(1337) == nil {
                let view = UIView(frame: CGRectMake(0, 0, cell.frame.width, cell.frame.height))
                view.backgroundColor = UIColor(named: .TransparentBlack)
                view.tag = 1337
                cell.addSubview(view)
            }
        }
    }
    
    /**
     Removes highlight when cell gets unselected.
     */
    override func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)?.viewWithTag(1337)?.removeFromSuperview()
    }
    
    //MARK: - Flow layout delegate
    
    /**
     Separates the cells in pairs.
     
     - Should change later on for iPad to display more cells in one row.
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        //return CGSize(width: collectionView.frame.width/2.2, height: collectionView.frame.width/2.2)
        
        let screenRect =  UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        let cellWidth = screenWidth / 3.5
        let size = CGSizeMake(cellWidth, cellWidth)
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
