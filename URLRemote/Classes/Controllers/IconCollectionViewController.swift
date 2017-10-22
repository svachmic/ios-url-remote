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

/// View controller taking care of icon selection.
class IconCollectionViewController: UICollectionViewController {
    let viewModel = IconCollectionViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.backgroundColor = UIColor(named: .gray)
        self.setupBar()
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
    
    /// Sets up all the buttons in the toolbar.
    func setupBar() {
        let cancel = MaterialFactory.cancelButton()
        cancel.reactive.tap.bind(to: self) { me, _ in
            me.parent?.dismiss(animated: true, completion: nil)
        }.dispose(in: bag)
        self.toolbarController?.toolbar.leftViews = [cancel]
        
        let done = MaterialFactory.doneButton()
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
        self.toolbarController?.toolbar.title = NSLocalizedString("SELECT_ICON", comment: "")
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.contents.sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.contents[section].items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.CollectionViewCell.iconCell,
            for: indexPath) as! IconCollectionViewCell
        cell.backgroundColor = viewModel.iconColor
        let imageName = viewModel.contents[indexPath.section].items[indexPath.row]
        cell.setIcon(named: imageName)
        cell.setIsHighlighted(viewModel.userSelection.value == indexPath)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: Constants.CollectionViewCell.iconsSection,
            for: indexPath) as! IconSectionCollectionReusableView
        
        cell.sectionNameLabel.text = NSLocalizedString(viewModel.contents[indexPath.section].metadata, comment: "")
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.userSelection.value = indexPath
        collectionView.reloadData()
    }
}

extension IconCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 30)
    }
}
