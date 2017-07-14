//
//  ActionsCollectionLayout.swift
//  URLRemote
//
//  Created by Michal Švácha on 25/05/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit

///
class ActionsCollectionLayout: UICollectionViewLayout {
    private var cellHeight: CGFloat = 10.0
    private var cellWidth: CGFloat = 10.0
    private let headerHeight: CGFloat = 80.0
    private let footerHeight: CGFloat = 50.0
    private var cellHorizontalOffset: CGFloat = 0.0
    private var cellVerticalOffset: CGFloat = 0.0
    
    var cellCache = [NSIndexPath: UICollectionViewLayoutAttributes]()
    var headerCache = [Int: UICollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return CGSize.zero
        }
        
        let screenWidth = collectionView.frame.width
        
        let contentWidth = CGFloat(collectionView.numberOfSections) * screenWidth
        let contentHeight = 3.0 * (cellHeight + cellHorizontalOffset) + cellHorizontalOffset
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // MARK: - Overriden mandatory methods
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        prepareMetrics()
        
        for section in 0..<collectionView.numberOfSections {
            headerCache[section] = headerAttributes(forSection: section)
            
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = NSIndexPath(item: item, section: section)
                cellCache[indexPath] = cellAttributes(forIndexPath: indexPath)
            }
        }
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return headerCache[indexPath.section]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellCache[indexPath as NSIndexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        
        for headerAttributes in headerCache.values {
            if rect.intersects(headerAttributes.frame) {
                attributesInRect.append(headerAttributes)
            }
        }
        
        for cellAttributes in cellCache.values {
            if rect.intersects(cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }
        
        return attributesInRect
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        
        cellCache = [:]
        headerCache = [:]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
    // MARK: - Private methods
    
    private func prepareMetrics() {
        guard let collectionView = collectionView else {
            return
        }
        
        cellWidth = (collectionView.frame.width / 3.0) * 0.9
        cellHeight = cellWidth
        cellHorizontalOffset = (collectionView.frame.width - (cellWidth * 3.0)) / 4.0
        cellVerticalOffset = ((collectionView.frame.height - headerHeight - footerHeight) - (cellHeight * 3.0)) / 4.0
    }
    
    private func cellAttributes(forIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes {
        let collectionViewWidth = collectionView?.frame.width ?? 0.0
        let xPageOffset = CGFloat(indexPath.section) * collectionViewWidth
        let xItemOffset = CGFloat(indexPath.item % 3) * (cellWidth + cellHorizontalOffset) + cellHorizontalOffset
        let yItemOffset = CGFloat(indexPath.item / 3) * (cellHeight + cellVerticalOffset)
        
        let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath as IndexPath)
        cellAttributes.frame = CGRect(
            x: xItemOffset + xPageOffset,
            y: yItemOffset + cellVerticalOffset + headerHeight,
            width: cellWidth,
            height: cellHeight)
        
        return cellAttributes
    }
    
    private func headerAttributes(forSection section: Int) -> UICollectionViewLayoutAttributes {
        let collectionViewWidth = collectionView?.frame.width ?? 0.0
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerAttributes = UICollectionViewLayoutAttributes(
            forSupplementaryViewOfKind: "header",
            with: indexPath)
        
        headerAttributes.frame = CGRect(
            x: collectionViewWidth * CGFloat(section),
            y: 0,
            width: collectionViewWidth,
            height: headerHeight)
        return headerAttributes
    }
}
