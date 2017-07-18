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
class ActionsCollectionViewController: UICollectionViewController, FABMenuDelegate {
    var viewModel: ActionsViewModel!
    var menu: FABMenu?
    var pageControl: UIPageControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
        collectionView?.backgroundColor = UIColor(named: .gray)
        
        collectionView?.register(CategoryViewCell.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "headerCell")
        
        self.setupNavigationController()
        self.setupMenu()
        self.setLoginNotifications()
        
        self.viewModel = ActionsViewModel()
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
        logout.titleColor = .white
        logout.pulseColor = .white
        logout.titleLabel?.font = RobotoFont.bold(with: 15)
        _ = logout.reactive.tap.observeNext {
            self.viewModel.logout()
        }
        self.navigationItem.leftViews = [logout]
        
        let settingsButton = IconButton(image: Icon.cm.settings, tintColor: .white)
        settingsButton.pulseColor = .white
        _ = settingsButton.reactive.tap.observeNext {
            print("Settings coming soon!")
        }
        
        let editButton = IconButton(image: Icon.cm.edit, tintColor: .white)
        editButton.pulseColor = .white
        _ = editButton.reactive.tap.observeNext {
            self.displayEditCategory()
        }
        
        self.navigationItem.rightViews = [editButton, settingsButton]
        
        self.navigationItem.titleLabel.textColor = .white
        self.navigationItem.detailLabel.textColor = .white
        
        self.navigationItem.title = "URLRemote"
        self.navigationItem.detail = "Making your IoT awesome!"
    }
    
    ///
    func setLoginNotifications() {
        NotificationCenter.default.reactive.notification(name: NSNotification.Name(rawValue: "USER_LOGGED_OUT"))
            .observeNext { _ in self.displayLogin() }
            .dispose(in: reactive.bag)
        
        NotificationCenter.default.reactive.notification(name: NSNotification.Name(rawValue: "USER_LOGGED_IN"))
            .observeNext { _ in self.setupCollectionDataSource() }
            .dispose(in: reactive.bag)
    }
    
    ///
    func setupCollectionDataSource() {
        pageControl = UIPageControl()
        pageControl?.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.4)
        pageControl?.currentPageIndicatorTintColor = UIColor.lightGray
        
        self.view.layout(pageControl!).bottom(30.0).centerHorizontally()
        
        _ = viewModel.data.observeNext { data in
            self.pageControl?.numberOfPages = data.dataSource.numberOfSections
            
            self.collectionView?.reloadData()
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }
        viewModel.bindDataSource()
    }
    
    ///
    func setupMenu() {
        self.menu = FABMenu()
        guard let menu = self.menu else { return }
        
        let addButton = FABButton(image: Icon.cm.add, tintColor: .white)
        addButton.frame = CGRect(x: 0.0, y: 0.0, width: 48.0, height: 48.0)
        addButton.pulseColor = .white
        addButton.backgroundColor = UIColor(named: .green).darker()
        _ = addButton.reactive.tap.observeNext { _ in self.menu?.toggle() }
        
        let entryItem = FABMenuItem()
        entryItem.fabButton.image = UIImage(named: "new_entry")
        entryItem.fabButton.tintColor = .white
        entryItem.fabButton.pulseColor = .white
        entryItem.fabButton.backgroundColor = Color.grey.base
        entryItem.fabButton.depthPreset = .depth1
        entryItem.title = NSLocalizedString("NEW_ENTRY", comment: "")
        _ = entryItem.fabButton.reactive.tap.observeNext {
            menu.toggle()
            self.displayEntrySetup()
        }
        
        let categoryItem = FABMenuItem()
        categoryItem.fabButton.image = UIImage(named: "new_category")
        categoryItem.fabButton.tintColor = .white
        categoryItem.fabButton.pulseColor = .white
        categoryItem.fabButton.backgroundColor = Color.grey.base
        categoryItem.title = NSLocalizedString("NEW_CATEGORY", comment: "")
        _ = categoryItem.fabButton.reactive.tap.observeNext {
            menu.toggle()
            self.displayCategorySetup()
        }
        
        menu.delegate = self
        menu.fabButton = addButton
        menu.fabMenuItems = [entryItem, categoryItem]
        menu.fabMenuItemSize = CGSize(width: 40.0, height: 40.0)
        
        let margin: CGFloat = 30.0
        self.view.layout(menu).size(addButton.frame.size).bottom(margin).right(margin)
    }
    
    /// MARK: - ViewController presentation
    
    ///
    func displayLogin() {
        let loginController = self.storyboard?.instantiateViewController(withIdentifier: "loginController")
        
        self.presentEmbedded(viewController: loginController!, barTintColor: UIColor(named: .green))
    }
    
    ///
    func displayEntrySetup() {
        let entryController = self.storyboard?.instantiateViewController(withIdentifier: "entrySetupController") as! EntrySetupViewController
        self.viewModel.dataSource?.entriesSignal()
            .map { return $0.count }
            .bind(to: entryController.viewModel.order)
        self.viewModel.dataSource?.categoriesSignal()
            .map { $0.name }
            .bind(to: entryController.viewModel.categories)
        entryController.viewModel.selectedCategoryIndex.value = pageControl!.currentPage
        
        self.presentEmbedded(viewController: entryController, barTintColor: UIColor(named: .green))
    }
    
    ///
    func displayCategorySetup() {
        let categoryDialog = UIAlertController(
            title: NSLocalizedString("NEW_CATEGORY", comment: ""),
            message: NSLocalizedString("NEW_CATEGORY_DESC", comment: ""),
            preferredStyle: .alert)
        
        categoryDialog.addAction(UIAlertAction(
            title: NSLocalizedString("CANCEL", comment: ""),
            style: .destructive,
            handler: nil))
        
        categoryDialog.addAction(UIAlertAction(
            title: NSLocalizedString("OK", comment: ""),
            style: .default,
            handler: { _ in
                if let textFields = categoryDialog.textFields, let textField = textFields[safe: 0], let text = textField.text, text != "" {
                    let cat = Category()
                    cat.name = text
                    cat.order = self.viewModel.data.numberOfSections
                    self.viewModel.dataSource?.write(cat)
                }
        }))
        
        categoryDialog.addTextField { textField in
            textField.placeholder = NSLocalizedString("NEW_CATEGORY_PLACEHOLDER", comment: "")
            _ = textField.reactive.text.map {
                guard let text = $0 else { return false }
                return text != ""
            }.observeNext { next in
                categoryDialog.actions[safe: 1]?.isEnabled = next
            }
        }
        
        self.present(categoryDialog, animated: true, completion: nil)
    }
    
    ///
    func displayEditCategory() {
        let visibleSection = collectionView?.indexPathsForVisibleSupplementaryElements(ofKind: "header")[safe: 0]?.section ?? 0
        
        let editCategoryController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.categoryEdit) as! CategoryEditTableViewController
        
        editCategoryController.viewModel.setupEntries(entries: viewModel.data[visibleSection].items)
        editCategoryController.viewModel.categories.insert(
            contentsOf: viewModel.data.sections.map { $0.metadata.name },
            at: 0)
        
        let category = viewModel.data[visibleSection].metadata
        editCategoryController.viewModel.categoryName.value = category.name
        
        _ = editCategoryController.viewModel.categoryName.observeNext {
            category.name = $0
            self.viewModel.dataSource?.write(category)
        }
        
        _ = editCategoryController.viewModel.signal.observeNext { entry in
            self.viewModel.dataSource?.write(entry)
        }
        
        _ = editCategoryController.viewModel.deleteSignal.observeNext { entry in
            self.viewModel.dataSource?.delete(entry)
        }
        
        self.presentEmbedded(viewController: editCategoryController, barTintColor: UIColor(named: .green))
    }
    
    /// MARK: - Menu delegate method
    
    ///
    public func fabMenu(fabMenu menu: FABMenu, tappedAt point: CGPoint, isOutside: Bool) {
        if isOutside {
            menu.toggle()
        }
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
            withReuseIdentifier: "entryCell",
            for: indexPath) as! ActionViewCell
        cell.setUpView()
        // Dispose all bindings because the cell objects are reused.
        cell.bag.dispose()
        cell.bind(with: viewModel.data[indexPath.section].items[indexPath.row])
        return cell
    }
    
    @objc(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: "headerCell", for: indexPath) as! CategoryViewCell
        header.setUpView()
        header.bind(with: viewModel.data[indexPath.section].metadata)
        return header
    }
}
