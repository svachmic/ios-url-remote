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
        viewModel = CategoryEditViewModel()
        viewModel.categories.append("category")
        viewModel.categoryName.value = "category"
        let entry1 = Entry(JSONString: "{\r\n\"firebaseKey\":\"abcdef\",\r\n\"order\":0,\r\n\"color\":4173881855,\r\n\"icon\":\"lightbulb_on\",\r\n\"name\":\"test\",\r\n\"requiresAuthentication\":true,\r\n\"user\":\"test_user\",\r\n\"password\":\"test_password\",\r\n\"type\":0,\r\n\"url\":\"https://www.seznam.cz\",\r\n\"customCriteria\":\"success\"\r\n}")!
        let entry2 = Entry(JSONString: "{\r\n\"firebaseKey\":\"ghijk\",\r\n\"order\":1,\r\n\"color\":4173881855,\r\n\"icon\":\"lightbulb_on\",\r\n\"name\":\"test\",\r\n\"requiresAuthentication\":true,\r\n\"user\":\"test_user\",\r\n\"password\":\"test_password\",\r\n\"type\":0,\r\n\"url\":\"https://www.seznam.cz\",\r\n\"customCriteria\":\"success\"\r\n}")!
        let entry3 = Entry(JSONString: "{\r\n\"firebaseKey\":\"lmnop\",\r\n\"order\":2,\r\n\"color\":4173881855,\r\n\"icon\":\"lightbulb_on\",\r\n\"name\":\"test\",\r\n\"requiresAuthentication\":true,\r\n\"user\":\"test_user\",\r\n\"password\":\"test_password\",\r\n\"type\":0,\r\n\"url\":\"https://www.seznam.cz\",\r\n\"customCriteria\":\"success\"\r\n}")!
        viewModel.setupEntries(entries: [entry1, entry2, entry3])
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEntriesSetup() {
        XCTAssertTrue(viewModel.entries.count == 3)
    }
    
    func testReplacement() {
        let entryReplacement = Entry(JSONString: "{\r\n\"firebaseKey\":\"lmnop\",\r\n\"order\":2,\r\n\"color\":4173881855,\r\n\"icon\":\"play\",\r\n\"name\":\"testReplacement\",\r\n\"requiresAuthentication\":true,\r\n\"user\":\"test_user\",\r\n\"password\":\"test_password\",\r\n\"type\":0,\r\n\"url\":\"https://www.seznam.cz\",\r\n\"customCriteria\":\"success\"\r\n}")!
        
        NotificationCenter.default.post(
            name: DataSourceNotifications.createdEntry.name,
            object: EntryDto(entry: entryReplacement, originalCategoryIndex: 0, categoryIndex: 0))
        XCTAssertTrue(viewModel.entries[2].firebaseKey == "lmnop")
        XCTAssertTrue(viewModel.entries[2].name == "testReplacement")
        XCTAssertTrue(viewModel.entries[2].icon == "play")
        
        let entryNonExistent = Entry(JSONString: "{\r\n\"firebaseKey\":\"xyz\",\r\n\"order\":2,\r\n\"color\":4173881855,\r\n\"icon\":\"play\",\r\n\"name\":\"testReplacement\",\r\n\"requiresAuthentication\":true,\r\n\"user\":\"test_user\",\r\n\"password\":\"test_password\",\r\n\"type\":0,\r\n\"url\":\"https://www.seznam.cz\",\r\n\"customCriteria\":\"success\"\r\n}")!
        NotificationCenter.default.post(
            name: DataSourceNotifications.createdEntry.name,
            object: EntryDto(entry: entryNonExistent, originalCategoryIndex: 0, categoryIndex: 0))
        let filtered = viewModel.entries.array.filter { $0.firebaseKey == "xyz" }
        XCTAssertTrue(filtered.count == 0)
    }
    
    func testMove() {
        XCTAssertTrue(viewModel.entries[0].firebaseKey == "abcdef")
        XCTAssertTrue(viewModel.entries[1].firebaseKey == "ghijk")
        XCTAssertTrue(viewModel.entries[2].firebaseKey == "lmnop")
        
        viewModel.moveItem(from: 2, to: 0)
        XCTAssertTrue(viewModel.entries[0].firebaseKey == "lmnop")
        XCTAssertTrue(viewModel.entries[1].firebaseKey == "abcdef")
        XCTAssertTrue(viewModel.entries[2].firebaseKey == "ghijk")
    }
    
    func testRemove() {
        viewModel.removeItem(index: 1)
        XCTAssertTrue(viewModel.entries.count == 2)
        let orderArray = viewModel.entries.array.map { $0.order }
        XCTAssertTrue(orderArray[0] == 0 && orderArray[1] == 1)
    }
}
