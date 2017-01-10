//
//  IconCollectionViewController.swift
//  URLRemote
//
//  Created by Michal Švácha on 10/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Material
import Bond
import ReactiveKit

///
class IconCollectionViewController: UICollectionViewController {
    private let reuseIdentifier = "iconCell"
    private let headerReuseIdentifier = "iconHeaderCell"
    
    let viewModel = IconCollectionViewModel()
    var iconColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.backgroundColor = UIColor(named: .gray)
        self.setupBar()
        
        if let initial = self.viewModel.initialSelection.value {
            self.viewModel.userSelection.value = initial
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        let viewFrame = self.view.frame
        
        if let collectionFrame = self.collectionView?.frame, viewFrame.height < collectionFrame.height {
            self.collectionView?.frame = CGRect(
                x: collectionFrame.origin.x,
                y: collectionFrame.origin.y,
                width: collectionFrame.width,
                height: viewFrame.height)
        }
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
        _ = combineLatest(
            self.viewModel.initialSelection,
            self.viewModel.userSelection)
            .map { return $0 != $1 }
            .bind(to: done.bnd_isEnabled)
        _ = done.bnd_tap.observeNext {
            if let indexPath = self.viewModel.userSelection.value {
                let icon = self.viewModel.contents[indexPath.section].items[indexPath.row]
                NotificationCenter.default.post(
                    name: NSNotification.Name(rawValue: "SELECTED_ICON"),
                    object: icon)
            }
            
            self.parent?.dismiss(animated: true, completion: nil)
        }
        self.toolbarController?.toolbar.rightViews = [done]
        
        self.toolbarController?.toolbar.titleLabel.textColor = .white
        self.toolbarController?.toolbar.title = NSLocalizedString("SELECT_ICON", comment: "")
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.contents.sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.contents[section].items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath) as! IconCollectionViewCell
        cell.backgroundColor = iconColor
        cell.layer.cornerRadius = cell.frame.width / 2.0
        
        let imageView = cell.viewWithTag(1) as? UIImageView
        let imageName = self.viewModel.contents[indexPath.section].items[indexPath.row]
        imageView?.image = UIImage(named: imageName)!.withRenderingMode(.alwaysTemplate)
        imageView?.tintColor = .white
        
        if self.viewModel.userSelection.value == indexPath {
            cell.highlight()
        } else {
            cell.unhighlight()
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier:headerReuseIdentifier,
            for: indexPath)
        
        let label = cell.viewWithTag(1) as? UILabel
        label?.font = RobotoFont.bold(with: 14)
        label?.textColor = .gray
        label?.text = NSLocalizedString(self.viewModel.contents[indexPath.section].metadata, comment: "")
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 30)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.userSelection.value = indexPath
        self.collectionView?.reloadData()
    }
}
