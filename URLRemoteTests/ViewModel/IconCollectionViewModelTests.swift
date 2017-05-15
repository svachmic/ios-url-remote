//
//  IconCollectionViewModelTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 15/05/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
@testable import URLRemote

class IconCollectionViewModelTests: XCTestCase {
    var viewModel: IconCollectionViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = IconCollectionViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testContents() {
        XCTAssertTrue(viewModel.contents.sections.count == 4)
    }
    
    func testSelection() {
        XCTAssertNil(viewModel.initialSelection.value)
        
        viewModel.setInitial(value: "on")
        XCTAssertTrue(viewModel.initialSelection.value == IndexPath(row: 2, section: 0))
        viewModel.setInitial(value: "play")
        XCTAssertTrue(viewModel.initialSelection.value == IndexPath(row: 0, section: 1))
        viewModel.setInitial(value: "night")
        XCTAssertTrue(viewModel.initialSelection.value == IndexPath(row: 3, section: 2))
        viewModel.setInitial(value: "double_up")
        XCTAssertTrue(viewModel.initialSelection.value == IndexPath(row: 4, section: 3))
        viewModel.setInitial(value: "")
        XCTAssertTrue(viewModel.initialSelection.value == IndexPath(row: 0, section: 0))
    }
}
