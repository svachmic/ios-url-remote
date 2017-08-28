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
    
    func testEquatability() {
        let categoryTest = Category()
        categoryTest.firebaseKey = "abcdef"
        XCTAssertEqual(category, categoryTest)
    }
    
    func testContains() {
        let noKeyEntry = Entry()
        noKeyEntry.firebaseKey = nil
        XCTAssertFalse(category.contains(entry: noKeyEntry))
        
        let validEntry = Entry()
        validEntry.firebaseKey = "abc"
        XCTAssertTrue(category.contains(entry: validEntry))
    }
    
    func testEntryAddition() {
        XCTAssertEqual(category.entryKeys.count, 3)
        
        let sameEntry = Entry()
        sameEntry.firebaseKey = "abc"
        category.add(entry: sameEntry)
        XCTAssertEqual(category.entryKeys.count, 3)
        
        let noKeyEntry = Entry()
        noKeyEntry.firebaseKey = nil
        category.add(entry: noKeyEntry)
        XCTAssertEqual(category.entryKeys.count, 3)
        
        let newEntry = Entry()
        newEntry.firebaseKey = "mno"
        category.add(entry: newEntry)
        XCTAssertEqual(category.entryKeys.count, 4)
    }
    
    func testEntryRemoval() {
        XCTAssertEqual(category.entryKeys.count, 3)
        
        let noKeyEntry = Entry()
        noKeyEntry.firebaseKey = nil
        category.remove(entry: noKeyEntry)
        XCTAssertEqual(category.entryKeys.count, 3)
        
        let existingEntry = Entry()
        existingEntry.firebaseKey = "abc"
        category.remove(entry: existingEntry)
        XCTAssertEqual(category.entryKeys.count, 2)
        
        let nonExistingEntry = Entry()
        nonExistingEntry.firebaseKey = "mno"
        category.remove(entry: nonExistingEntry)
        XCTAssertEqual(category.entryKeys.count, 2)
    }
}
