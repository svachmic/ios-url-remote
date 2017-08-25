//
//  ActionsViewModelTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 27/08/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
@testable import URLRemote

class ActionsViewModelTests: XCTestCase {
    var viewModel: ActionsViewModel!
    
    override func setUp() {
        super.setUp()
        
        viewModel = ActionsViewModel()
        viewModel.dataSource.value = MockDataSource()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDataConsistency() {
        XCTAssertTrue(viewModel.data.sections.count == 0)
        
        let entry = Entry(JSONString: "{\r\n\"firebaseKey\":\"abc\",\r\n\"order\":1,\r\n\"color\":4173881855,\r\n\"icon\":\"lightbulb_on\",\r\n\"name\":\"test\",\r\n\"requiresAuthentication\":true,\r\n\"user\":\"test_user\",\r\n\"password\":\"test_password\",\r\n\"type\":0,\r\n\"url\":\"https://www.seznam.cz\",\r\n\"customCriteria\":\"success\"\r\n}")!
        let category = Category(JSONString: "{\r\n\"firebaseKey\":\"abcdefg\",\r\n\"order\":0,\r\n\"name\":\"test category\",\r\n\"entryKeys\":[\"abc\"]\r\n}")!
        viewModel.dataSource.value?.write(entry: entry, category: category)
        
        XCTAssertTrue(viewModel.data.sections.count == 1)
        XCTAssertTrue(viewModel.data[0].items.count == 1)
    }
    
    func testCombinerDisposal() {
        XCTAssertNotNil(viewModel.combiner)
        XCTAssertFalse(viewModel.combiner!.isDisposed)
        
        viewModel.dataSource.value = nil
        XCTAssertTrue(viewModel.combiner!.isDisposed)
    }
}
