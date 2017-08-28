//
//  SettingsViewModelTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 15/05/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
@testable import URLRemote

class CategoryEditViewModelTests: XCTestCase {
    var viewModel: CategoryEditViewModel!
    
    override func setUp() {
        super.setUp()
        let entry1 = Entry(JSONString: "{\r\n\"firebaseKey\":\"abcdef\",\r\n\"order\":0,\r\n\"color\":4173881855,\r\n\"icon\":\"lightbulb_on\",\r\n\"name\":\"test\",\r\n\"requiresAuthentication\":true,\r\n\"user\":\"test_user\",\r\n\"password\":\"test_password\",\r\n\"type\":0,\r\n\"url\":\"https://www.seznam.cz\",\r\n\"customCriteria\":\"success\"\r\n}")!
        let entry2 = Entry(JSONString: "{\r\n\"firebaseKey\":\"ghijk\",\r\n\"order\":1,\r\n\"color\":4173881855,\r\n\"icon\":\"lightbulb_on\",\r\n\"name\":\"test\",\r\n\"requiresAuthentication\":true,\r\n\"user\":\"test_user\",\r\n\"password\":\"test_password\",\r\n\"type\":0,\r\n\"url\":\"https://www.seznam.cz\",\r\n\"customCriteria\":\"success\"\r\n}")!
        let entry3 = Entry(JSONString: "{\r\n\"firebaseKey\":\"lmnop\",\r\n\"order\":2,\r\n\"color\":4173881855,\r\n\"icon\":\"lightbulb_on\",\r\n\"name\":\"test\",\r\n\"requiresAuthentication\":true,\r\n\"user\":\"test_user\",\r\n\"password\":\"test_password\",\r\n\"type\":0,\r\n\"url\":\"https://www.seznam.cz\",\r\n\"customCriteria\":\"success\"\r\n}")!
        
        let category = Category(JSONString: "{\r\n\"firebaseKey\":\"abcdef\",\r\n\"order\":0,\r\n\"name\":\"category\",\r\n\"entryKeys\":[\"abcdef\",\"ghijk\",\"lmnop\"]\r\n}")!
        
        let dataSource = MockDataSource()
        dataSource.update(category)
        dataSource.update(entry1)
        dataSource.update(entry2)
        dataSource.update(entry3)
        
        viewModel = CategoryEditViewModel(dataSource: dataSource)
        viewModel.category = category
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEntriesSetup() {
        XCTAssertTrue(viewModel.entries.count == 3)
    }
    
    func testCategoryRename() {
        XCTAssertEqual(viewModel.category!.name, "category")
        
        viewModel.renameCategory(name: "test")
        XCTAssertEqual(viewModel.category!.name, "test")
    }
    
    func testCategoryRemoval() {
        viewModel.removeCategory()
        
        XCTAssertEqual(viewModel.entries.count, 0)
    }
    
    func testReplacement() {
        XCTAssertTrue(viewModel.entries[2].firebaseKey == "lmnop")
        XCTAssertTrue(viewModel.entries[2].name == "test")
        XCTAssertTrue(viewModel.entries[2].icon == "lightbulb_on")
        
        let dataSource = viewModel.dataSource
        let entryReplacement = Entry(JSONString: "{\r\n\"firebaseKey\":\"lmnop\",\r\n\"order\":2,\r\n\"color\":4173881855,\r\n\"icon\":\"play\",\r\n\"name\":\"testReplacement\",\r\n\"requiresAuthentication\":true,\r\n\"user\":\"test_user\",\r\n\"password\":\"test_password\",\r\n\"type\":0,\r\n\"url\":\"https://www.seznam.cz\",\r\n\"customCriteria\":\"success\"\r\n}")!
        dataSource.update(entryReplacement)
        XCTAssertTrue(viewModel.entries[2].firebaseKey == "lmnop")
        XCTAssertTrue(viewModel.entries[2].name == "testReplacement")
        XCTAssertTrue(viewModel.entries[2].icon == "play")
        
        let entryNonExistent = Entry(JSONString: "{\r\n\"firebaseKey\":\"xyz\",\r\n\"order\":2,\r\n\"color\":4173881855,\r\n\"icon\":\"play\",\r\n\"name\":\"testReplacement\",\r\n\"requiresAuthentication\":true,\r\n\"user\":\"test_user\",\r\n\"password\":\"test_password\",\r\n\"type\":0,\r\n\"url\":\"https://www.seznam.cz\",\r\n\"customCriteria\":\"success\"\r\n}")!
        dataSource.update(entryNonExistent)
        let filtered = viewModel.entries.array
            .filter { $0.firebaseKey == "xyz" }
        XCTAssertTrue(filtered.count == 0)
    }
    
    func testAsyncShuffle() {
        XCTAssertTrue(viewModel.entries[0].firebaseKey == "abcdef")
        XCTAssertEqual(viewModel.entries[0].order, 0)
        XCTAssertTrue(viewModel.entries[1].firebaseKey == "ghijk")
        XCTAssertEqual(viewModel.entries[1].order, 1)
        XCTAssertTrue(viewModel.entries[2].firebaseKey == "lmnop")
        XCTAssertEqual(viewModel.entries[2].order, 2)
        
        let category = Category()
        category.firebaseKey = "testkey"
        viewModel.dataSource.move(viewModel.entries[0], from: viewModel.category!, to: category)
        XCTAssertTrue(viewModel.entries[0].firebaseKey == "ghijk")
        XCTAssertEqual(viewModel.entries[0].order, 0)
        XCTAssertTrue(viewModel.entries[1].firebaseKey == "lmnop")
        XCTAssertEqual(viewModel.entries[1].order, 1)
    }
    
    func testMove() {
        XCTAssertTrue(viewModel.entries[0].firebaseKey == "abcdef")
        XCTAssertTrue(viewModel.entries[0].order == 0)
        XCTAssertTrue(viewModel.entries[1].firebaseKey == "ghijk")
        XCTAssertTrue(viewModel.entries[1].order == 1)
        XCTAssertTrue(viewModel.entries[2].firebaseKey == "lmnop")
        XCTAssertTrue(viewModel.entries[2].order == 2)
        
        viewModel.moveItem(from: 2, to: 0)
        XCTAssertTrue(viewModel.entries[0].firebaseKey == "lmnop")
        XCTAssertTrue(viewModel.entries[0].order == 0)
        XCTAssertTrue(viewModel.entries[1].firebaseKey == "abcdef")
        XCTAssertTrue(viewModel.entries[1].order == 1)
        XCTAssertTrue(viewModel.entries[2].firebaseKey == "ghijk")
        XCTAssertTrue(viewModel.entries[2].order == 2)
    }
    
    func testRemove() {
        var dataArray = [Entry]()
        let tested = viewModel.dataSource.entries(under: viewModel.category!).observeNext {
            dataArray = $0
        }
        /// Check that underlying data source starts with the same data
        XCTAssertTrue(dataArray.count == 3)
        
        viewModel.removeItem(index: 1)
        XCTAssertTrue(viewModel.entries.count == 2)
        
        /// Check that underlying data source has been altered as well
        XCTAssertTrue(dataArray.count == 2)
        
        /// View Model consistency check
        let orderArray = viewModel.entries.array.map { $0.order }
        XCTAssertTrue(orderArray[0] == 0 && orderArray[1] == 1)
        
        // Continued removal to reach needsShuffle == false on empty array
        viewModel.removeItem(index: 0)
        viewModel.removeItem(index: 0)
        XCTAssertTrue(viewModel.entries.isEmpty)
        
        tested.dispose()
    }
}
