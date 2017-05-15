//
//  EntryTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 15/05/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
@testable import URLRemote

class EntryTests: XCTestCase {
    var entry: Entry!
    
    override func setUp() {
        super.setUp()
        entry = Entry(JSONString: "{\r\n\"firebaseKey\":\"abcdef\",\r\n\"order\":1,\r\n\"color\":4173881855,\r\n\"icon\":\"lightbulb_on\",\r\n\"name\":\"test\",\r\n\"requiresAuthentication\":true,\r\n\"user\":\"test_user\",\r\n\"password\":\"test_password\",\r\n\"type\":0,\r\n\"url\":\"https://www.seznam.cz\",\r\n\"customCriteria\":\"success\"\r\n}")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEntryContents() {
        XCTAssertNotNil(entry)
        XCTAssertTrue(entry.color == ColorName.yellow)
        XCTAssertTrue(entry.icon == "lightbulb_on")
        XCTAssertTrue(entry.name == "test")
        XCTAssertTrue(entry.requiresAuthentication)
        XCTAssertTrue(entry.user == "test_user")
        XCTAssertTrue(entry.password == "test_password")
        XCTAssertTrue(entry.type == EntryType.Custom)
        XCTAssertTrue(entry.customCriteria == "success")
        XCTAssertTrue(entry.url == "https://www.seznam.cz")
    }
    
    func testEntryType() {
        let custom = EntryType(rawValue: 0)
        XCTAssertTrue(custom == EntryType.Custom)
        XCTAssertTrue(custom?.description() == NSLocalizedString("TYPE_CUSTOM_DESC", comment: ""))
        XCTAssertTrue(custom?.toString() == NSLocalizedString("TYPE_CUSTOM", comment: ""))
        
        let simple = EntryType(rawValue: 1)
        XCTAssertTrue(simple == EntryType.SimpleHTTP)
        XCTAssertTrue(simple?.description() == NSLocalizedString("TYPE_SIMPLE_HTTP_DESC", comment: ""))
        XCTAssertTrue(simple?.toString() == NSLocalizedString("TYPE_SIMPLE_HTTP", comment: ""))
        
        let quido = EntryType(rawValue: 2)
        XCTAssertTrue(quido == EntryType.Quido)
        XCTAssertTrue(quido?.description() == NSLocalizedString("TYPE_QUIDO_DESC", comment: ""))
        XCTAssertTrue(quido?.toString() == NSLocalizedString("TYPE_QUIDO", comment: ""))
    }
}
