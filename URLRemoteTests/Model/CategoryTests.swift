//
//  CategoryTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 15/05/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
@testable import URLRemote

class CategoryTests: XCTestCase {
    var category: URLRemote.Category!
    
    override func setUp() {
        super.setUp()
        category = Category(JSONString: "{\r\n\"firebaseKey\":\"abcdef\",\r\n\"order\":0,\r\n\"name\":\"test category\",\r\n\"entryKeys\":[\"abc\",\"def\",\"ghi\"]\r\n}")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testParsing() {
        XCTAssertNotNil(category)
        XCTAssertTrue(category.name == "test category")
        XCTAssertTrue(category.entryKeys.count == 3)
    }
    
    func testInitializer() {
        let categoryTest = Category()
        categoryTest.name = "test category"
        categoryTest.entryKeys = ["abc", "def", "ghi"]
        XCTAssertEqual(categoryTest.name, category.name)
        XCTAssertEqual(categoryTest.entryKeys.count, category.entryKeys.count)
    }
}
