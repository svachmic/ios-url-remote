//
//  EntrySetupViewModelTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 15/05/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
@testable import URLRemote

class EntrySetupViewModelTests: XCTestCase {
    var viewModel: EntrySetupViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = EntrySetupViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testValidation() {
        XCTAssertFalse(viewModel.isFormComplete.value)
        
        viewModel.name.value = "test"
        XCTAssertFalse(viewModel.isFormComplete.value)
        
        viewModel.url.value = "not_a_url"
        XCTAssertFalse(viewModel.isFormComplete.value)
        
        viewModel.url.value = "https://www.seznam.cz"
        XCTAssertTrue(viewModel.isFormComplete.value)
        
        viewModel.requiresAuthentication.value = true
        XCTAssertFalse(viewModel.isFormComplete.value)
        
        viewModel.user.value = ""
        viewModel.password.value = ""
        XCTAssertFalse(viewModel.isFormComplete.value)
        
        viewModel.user.value = "test_user"
        viewModel.password.value = "test_password"
        XCTAssertTrue(viewModel.isFormComplete.value)
    }
    
    func testTypeSwitching() {
        XCTAssertTrue(viewModel.type.value == EntryType.SimpleHTTP)
        XCTAssertTrue(viewModel.contents.count == 3)
        
        viewModel.type.value = EntryType.Custom
        XCTAssertTrue(viewModel.contents.count == 4)
        
        viewModel.type.value = EntryType.SimpleHTTP
        XCTAssertTrue(viewModel.contents.count == 3)
    }
    
    func testIconNotification() {
        XCTAssertTrue(viewModel.icon.value == "plus")
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "SELECTED_ICON"),
            object: "play")
        XCTAssertTrue(viewModel.icon.value == "play")
    }
    
    func testSetup() {
        let entry = Entry(JSONString: "{\r\n\"firebaseKey\":\"abcdef\",\r\n\"order\":1,\r\n\"color\":4173881855,\r\n\"icon\":\"lightbulb_on\",\r\n\"name\":\"test\",\r\n\"requiresAuthentication\":true,\r\n\"user\":\"test_user\",\r\n\"password\":\"test_password\",\r\n\"type\":0,\r\n\"url\":\"https://www.seznam.cz\",\r\n\"customCriteria\":\"success\"\r\n}")!
        viewModel.setup(with: entry)
        
        XCTAssertTrue(viewModel.firebaseKey == entry.firebaseKey)
        XCTAssertTrue(viewModel.order.value == entry.order)
        XCTAssertTrue(viewModel.name.value == entry.name)
        XCTAssertTrue(viewModel.color.value == entry.color)
        XCTAssertTrue(viewModel.icon.value == entry.icon)
        XCTAssertTrue(viewModel.url.value == entry.url)
        XCTAssertTrue(viewModel.type.value == entry.type)
        XCTAssertTrue(viewModel.requiresAuthentication.value == entry.requiresAuthentication)
        XCTAssertTrue(viewModel.user.value == entry.user)
        XCTAssertTrue(viewModel.password.value == entry.password)
        XCTAssertTrue(viewModel.customCriteria.value == entry.customCriteria)
        
        entry.name = nil
        entry.color = nil
        entry.icon = nil
        entry.url = nil
        entry.type = nil
        entry.customCriteria = nil
        viewModel.setup(with: entry)
        XCTAssertTrue(viewModel.name.value == "")
        XCTAssertTrue(viewModel.color.value == ColorName.yellow)
        XCTAssertTrue(viewModel.icon.value == "plus")
        XCTAssertTrue(viewModel.url.value == "")
        XCTAssertTrue(viewModel.type.value == EntryType.SimpleHTTP)
        XCTAssertTrue(viewModel.customCriteria.value == "")
    }
    
    func testToEntry() {
        let entry = Entry(JSONString: "{\r\n\"firebaseKey\":\"abcdef\",\r\n\"order\":1,\r\n\"color\":4173881855,\r\n\"icon\":\"lightbulb_on\",\r\n\"name\":\"test\",\r\n\"requiresAuthentication\":true,\r\n\"user\":\"test_user\",\r\n\"password\":\"test_password\",\r\n\"type\":0,\r\n\"url\":\"https://www.seznam.cz\",\r\n\"customCriteria\":\"success\"\r\n}")!
        viewModel.setup(with: entry)
        
        let viewModelOutputEntry = viewModel.toEntry()
        XCTAssertTrue(viewModelOutputEntry.firebaseKey == entry.firebaseKey)
        XCTAssertTrue(viewModelOutputEntry.order == entry.order)
        XCTAssertTrue(viewModelOutputEntry.name == entry.name)
        XCTAssertTrue(viewModelOutputEntry.color == entry.color)
        XCTAssertTrue(viewModelOutputEntry.icon == entry.icon)
        XCTAssertTrue(viewModelOutputEntry.url == entry.url)
        XCTAssertTrue(viewModelOutputEntry.type == entry.type)
        XCTAssertTrue(viewModelOutputEntry.requiresAuthentication == entry.requiresAuthentication)
        XCTAssertTrue(viewModelOutputEntry.user == entry.user)
        XCTAssertTrue(viewModelOutputEntry.password == entry.password)
        XCTAssertTrue(viewModelOutputEntry.customCriteria == entry.customCriteria)
    }
}
