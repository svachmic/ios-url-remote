//
//  ActionsCollectionLayoutTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 26/05/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
@testable import URLRemote

class ActionsCollectionLayoutTests: XCTestCase {
    let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 375, height: 667), collectionViewLayout: ActionsCollectionLayout())
    
    override func setUp() {
        super.setUp()
        
        collectionView.register(TestUICollectionViewCell.self, forCellWithReuseIdentifier: "testCell")
        collectionView.register(TestUICollectionViewHeader.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "testHeader")
        
        collectionView.dataSource = self
        collectionView.reloadData()
        collectionView.collectionViewLayout.prepare()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCorrectTypes() {
        let cell = self.collectionView(
            collectionView,
            cellForItemAt: IndexPath(row: 0, section: 0))
        let asCell = cell as? TestUICollectionViewCell
        XCTAssertNotNil(asCell)
        
        let header = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: "header",
            at: IndexPath(row: 0, section: 0))
        let asHeader = header as? TestUICollectionViewHeader
        XCTAssertNotNil(asHeader)
    }
    
    func testContentSize() {
        let contentWidth = collectionView.collectionViewLayout.collectionViewContentSize.width
        let expectedWidth = 2.0 * collectionView.frame.width
        XCTAssertEqual(contentWidth, expectedWidth)
    }
    
    func testAttributesConsistency() {
        let attributes = collectionView.collectionViewLayout.layoutAttributesForElements(in: collectionView.frame)
        print(collectionView.frame)
        XCTAssertEqual(attributes?.count, 10)
        
        let headerCount = attributes?.filter { $0.representedElementKind == "header" }.count
        XCTAssertEqual(headerCount, 1)
        
        let cellCount = attributes?.filter { $0.representedElementKind != "header" }.count
        XCTAssertEqual(cellCount, 9)
    }
    
    func testItems() {
        let itemCount = self.collectionView(
            collectionView,
            numberOfItemsInSection: 0)
        XCTAssertEqual(itemCount, 9)
        
        let cells = (0..<itemCount).map { (item: Int) -> UICollectionViewCell in
            return self.collectionView(
                collectionView,
                cellForItemAt: IndexPath(item: item, section: 0))
        }
        
        let overlappingCount = cells.map { cell in
            return cells.filter { $0.frame.intersects(cell.frame) }.count
        }.reduce(0, +)
        XCTAssertEqual(overlappingCount, 9)
    }
    
    func testHeaders() {
        let header = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: "header",
            at: IndexPath(row: 0, section: 0))
        XCTAssertEqual(header.frame.origin.x, 0.0)
        XCTAssertEqual(header.frame.origin.y, 0.0)
        
        let cells = (0..<3).map { (item: Int) -> Bool in
            let cell = self.collectionView(
                collectionView,
                cellForItemAt: IndexPath(item: item, section: 0))
            return header.frame.intersects(cell.frame)
            }.reduce(false) { $0 && $1}
        
        XCTAssertFalse(cells)
    }
}

fileprivate class TestUICollectionViewCell: UICollectionViewCell { }
fileprivate class TestUICollectionViewHeader: UICollectionReusableView { }

extension ActionsCollectionLayoutTests: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 9 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "testCell", for: indexPath)
        return cell
    }
    
    @objc(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "testHeader", for: indexPath)
        return header
    }
}
