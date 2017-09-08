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
    
    func testIsFull() {
        XCTAssertEqual(category.entryKeys.count, 3)
        
        let e1 = Entry()
        e1.firebaseKey = "1"
        category.add(entry: e1)
        let e2 = Entry()
        e2.firebaseKey = "2"
        category.add(entry: e2)
        let e3 = Entry()
        e3.firebaseKey = "3"
        category.add(entry: e3)
        let e4 = Entry()
        e4.firebaseKey = "4"
        category.add(entry: e4)
        let e5 = Entry()
        e5.firebaseKey = "5"
        category.add(entry: e5)
        let e6 = Entry()
        e6.firebaseKey = "6"
        category.add(entry: e6)
        XCTAssertEqual(category.entryKeys.count, 9)
        XCTAssertTrue(category.isFull())
        
        let e7 = Entry()
        e7.firebaseKey = "7"
        category.add(entry: e7)
        XCTAssertEqual(category.entryKeys.count, 9)
    }
}
