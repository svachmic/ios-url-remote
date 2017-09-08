//
//  MockDataSourceTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 09/09/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
import Bond
@testable import URLRemote

class MockDataSourceTests: XCTestCase {
    let dataSource = MockDataSource()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDataFilling() {
        let categories = MutableObservableArray<URLRemote.Category>()
        XCTAssertEqual(categories.count, 0)
        let entries = MutableObservableArray<Entry>()
        XCTAssertEqual(entries.count, 0)
        
        let categoryDisposable = dataSource.categories().observeNext {
            categories.replace(with: $0, performDiff: true)
        }
        
        let entryDisposable = dataSource.entries().observeNext {
            entries.replace(with: $0, performDiff: true)
        }
        
        dataSource.fillWithTestData()
        XCTAssertEqual(categories.count, 3)
        XCTAssertEqual(entries.count, 13)
        
        categoryDisposable.dispose()
        entryDisposable.dispose()
    }
}
