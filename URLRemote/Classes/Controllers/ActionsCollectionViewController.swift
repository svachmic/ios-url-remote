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
class ActionsCollectionViewController: UICollectionViewController, PersistenceStackController {
    var stack: PersistenceStack! {
        didSet {
            viewModel = ActionsViewModel()
        }
    }
    var viewModel: ActionsViewModel!
    
    var menu: FABMenu?
    var pageControl: UIPageControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
        collectionView?.backgroundColor = UIColor(named: .gray)
        
        collectionView?.register(CategoryViewCell.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: Constants.CollectionViewCell.header)
        
        self.setupNavigationController()
        self.setupMenu()
        self.setLoginNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - View setup
    
    ///
    func setupNavigationController() {
        let navigationController = self.navigationController as? ApplicationNavigationController
        
        navigationController?.prepare()
        navigationController?.statusBarStyle = .lightContent
        navigationController?.navigationBar.barTintColor = UIColor(named: .yellow)
        
        let logout = FlatButton(title: NSLocalizedString("LOGOUT", comment: ""))
        logout.apply(Stylesheet.General.flatButton)
        logout.reactive.tap.bind(to: self) { me, _ in
            me.stack.authentication.logOut()
        }.dispose(in: bag)
        self.navigationItem.leftViews = [logout]
        
        let settingsButton = MaterialFactory.genericIconButton(image: Icon.cm.settings)
        settingsButton.reactive.tap.bind(to: self) { _, _ in
            print("Settings coming soon!")
        }.dispose(in: bag)
        
        let editButton = MaterialFactory.genericIconButton(image: Icon.cm.edit)
        editButton.reactive.tap.bind(to: self) { me, _ in
            me.displayEditCategory()
        }.dispose(in: bag)
        
        self.navigationItem.rightViews = [editButton, settingsButton]
        
        self.navigationItem.titleLabel.textColor = .white
        self.navigationItem.detailLabel.textColor = .white
        
        self.navigationItem.titleLabel.text = "URLRemote"
        self.navigationItem.detailLabel.text = "Making your IoT awesome!"
    }
    
    ///
    func setLoginNotifications() {
        stack.authentication
            .dataSource()
            .observeNext {
                if let src = $0 {
                    self.viewModel.dataSource.value = src
                    self.setupCollectionDataSource()
                } else {
                    self.viewModel.dataSource.value = nil
                    self.resetCollectionDataSource()
                    self.displayLogin()
                }
            }
            .dispose(in: bag)
    }
    
    ///
    func setupCollectionDataSource() {
        pageControl = UIPageControl()
        pageControl?.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.4)
        pageControl?.currentPageIndicatorTintColor = UIColor.lightGray
        
        self.view.layout(pageControl!).bottom(30.0).centerHorizontally()
        
        viewModel.data.bind(to: self) { me, data in
            me.pageControl?.numberOfPages = data.dataSource.numberOfSections
            
            me.collectionView?.reloadData()
            me.collectionView?.collectionViewLayout.invalidateLayout()
        }.dispose(in: bag)
    }
    
    ///
    func resetCollectionDataSource() {
        pageControl?.removeFromSuperview()
        collectionView?.contentOffset = CGPoint(x: 0, y: 0)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    /// MARK: - ViewController presentation
    
    ///
    func displayLogin() {
        let loginController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.login) as! LoginTableViewController
        loginController.stack = stack
        self.presentEmbedded(viewController: loginController, barTintColor: UIColor(named: .green))
    }
    
    ///
    func displayEntrySetup() {
        let entryController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.entrySetup) as! EntrySetupViewController
        entryController.stack = stack
        self.presentEmbedded(viewController: entryController, barTintColor: UIColor(named: .green))
    }
    
    ///
    func displayCategorySetup() {
        let categoryDialog = AlertDialogBuilder
            .dialog(title: "NEW_CATEGORY", text: "NEW_CATEGORY_DESC")
            .cancelAction()
        
        let okAction = UIAlertAction(
            title: NSLocalizedString("OK", comment: ""),
            style: .default,
            handler: { _ in
                if let textFields = categoryDialog.textFields, let textField = textFields[safe: 0], let text = textField.text, text != "" {
                    self.viewModel.createCategory(named: text)
                }
        })
        categoryDialog.addAction(okAction)
        
        categoryDialog.addTextField { textField in
            textField.placeholder = NSLocalizedString("NEW_CATEGORY_PLACEHOLDER", comment: "")
            textField.reactive
                .isEmpty
                .bind(to: okAction.reactive.enabled)
                .dispose(in: categoryDialog.bag)
        }
        
        self.present(categoryDialog, animated: true, completion: nil)
    }
    
    ///
    func displayEditCategory() {
        let visibleSection = collectionView?.indexPathsForVisibleSupplementaryElements(ofKind: "header")[safe: 0]?.section ?? 0
        
        let editCategoryController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.categoryEdit) as! CategoryEditTableViewController
        editCategoryController.stack = stack
        
        let category = viewModel.data[visibleSection].metadata
        editCategoryController.viewModel.category = category
        
        self.presentEmbedded(viewController: editCategoryController, barTintColor: UIColor(named: .green))
    }
    
    // MARK: - Collection view data source methods
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int(floor((scrollView.contentOffset.x - pageWidth / 2.0) / pageWidth) + 1.0)
        pageControl?.currentPage = currentPage
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        collectionView.collectionViewLayout.invalidateLayout()
        return viewModel.data.sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data[section].items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.CollectionViewCell.entry,
            for: indexPath) as! ActionViewCell
        cell.setUpView()
        // Dispose all bindings because the cell objects are reused.
        cell.bag.dispose()
        cell.bind(with: viewModel.data[indexPath.section].items[indexPath.row])
        return cell
    }
    
    @objc(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: Constants.CollectionViewCell.header, for: indexPath) as! CategoryViewCell
        header.setUpView()
        header.bind(with: viewModel.data[indexPath.section].metadata)
        return header
    }
}

//
extension ActionsCollectionViewController: FABMenuDelegate {
    
    ///
    private func genericMenuItem(image: String, title: String) -> FABMenuItem {
        let item = FABMenuItem()
        item.fabButton.image = UIImage(named: image)
        item.fabButton.apply(Stylesheet.Actions.fabButton)
        item.title = NSLocalizedString(title, comment: "")
        return item
    }
    
    ///
    private func menuEntryItem() -> FABMenuItem {
        let entryItem = genericMenuItem(image: "new_entry", title: "NEW_ENTRY")
        entryItem.fabButton.depthPreset = .depth1
        entryItem.fabButton.reactive.tap.observeNext { [weak self] in
            self?.menu?.toggle()
            self?.displayEntrySetup()
        }.dispose(in: bag)
        
        return entryItem
    }
    
    ///
    private func menuCategoryItem() -> FABMenuItem {
        let categoryItem = genericMenuItem(image: "new_category", title: "NEW_CATEGORY")
        categoryItem.fabButton.reactive.tap.observeNext { [weak self] in
            self?.menu?.toggle()
            self?.displayCategorySetup()
        }.dispose(in: bag)
        
        return categoryItem
    }
    
    ///
    func setupMenu() {
        self.menu = FABMenu()
        
        let addButton = FABButton(image: Icon.cm.add, tintColor: .white)
        addButton.frame = CGRect(x: 0.0, y: 0.0, width: 48.0, height: 48.0)
        addButton.pulseColor = .white
        addButton.backgroundColor = UIColor(named: .green).darker()
        addButton.reactive.tap
            .observeNext { [weak self] in self?.menu?.toggle() }
            .dispose(in: bag)
        
        menu?.delegate = self
        menu?.fabButton = addButton
        menu?.fabMenuItems = [menuEntryItem(), menuCategoryItem()]
        menu?.fabMenuItemSize = CGSize(width: 40.0, height: 40.0)
        
        view.layout(menu!).size(addButton.frame.size).bottom(30).right(30)
    }
    
    /// MARK: - Menu delegate method
    
    ///
    public func fabMenu(fabMenu menu: FABMenu, tappedAt point: CGPoint, isOutside: Bool) {
        if isOutside {
            menu.toggle()
        }
    }
}
