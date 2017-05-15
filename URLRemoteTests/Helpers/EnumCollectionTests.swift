//
//  EnumCollectionTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 15/02/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
@testable import URLRemote

class EnumCollectionTests: XCTestCase {
    
    /// Test enum for the purposes of the test
    enum TestEnum: EnumCollection {
        case first
        case second
        case third
    }
    
    var collection: [TestEnum] = []
    
    override func setUp() {
        super.setUp()
        collection = TestEnum.allValues
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /// Tests presence of all enum values in an enum allValues collection.
    func testPresence() {
        XCTAssertTrue(collection.count == 3)
        XCTAssertTrue(collection.contains(.first))
        XCTAssertTrue(collection.contains(.second))
        XCTAssertTrue(collection.contains(.third))
    }
    
    /// Tests order of the enum values - should be the same as defined.
    func testOrder() {
        XCTAssertEqual(collection[0], .first)
        XCTAssertEqual(collection[1], .second)
        XCTAssertEqual(collection[2], .third)
    }
}
