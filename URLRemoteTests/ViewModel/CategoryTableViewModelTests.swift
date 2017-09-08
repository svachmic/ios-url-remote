//
//  CategoryTableViewModelTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 08/09/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
import Bond
@testable import URLRemote

class CategoryTableViewModelTests: XCTestCase {
    var viewModel: CategoryTableViewModel!
    
    override func setUp() {
        super.setUp()
        
        viewModel = CategoryTableViewModel()
        
        let c1 = Category()
        c1.firebaseKey = "1"
        c1.name = "c1"
        let c2 = Category()
        c2.firebaseKey = "2"
        c2.entryKeys = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
        c2.name = "c2"
        let c3 = Category()
        c3.firebaseKey = "3"
        c3.name = "c3"
        viewModel.contents.insert(contentsOf: [c1, c2, c3], at: 0)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialSelection() {
        XCTAssertEqual(viewModel.userSelection.value, 0)
        viewModel.initialSelection.value = 2
        XCTAssertEqual(viewModel.userSelection.value, 2)
    }
    
    func testSelection() {
        XCTAssertEqual(viewModel.userSelection.value, 0)
        
        // out of bounds
        viewModel.selected(5)
        XCTAssertEqual(viewModel.userSelection.value, 0)
        
        // full category
        viewModel.selected(1)
        XCTAssertEqual(viewModel.userSelection.value, 0)
    }
    
    func testDone() {
        let observed = Observable<Int>(1)
        XCTAssertEqual(observed.value, 1)
        
        let disposable = viewModel.signal.bind(to: observed)
        viewModel.selected(2)
        viewModel.done()
        XCTAssertEqual(observed.value, 2)
        disposable.dispose()
    }
}
