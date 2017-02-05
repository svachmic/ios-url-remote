//
//  ArrayExtensionTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 14/02/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest

class ArrayExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /// Tests subscript and returning valid values instead of crashing.
    func testSafeSubscript() {
        var array = [0, 1]
        XCTAssertNotNil(array[safe: 0])
        XCTAssertEqual(array[safe: 0], 0)
        XCTAssertNotNil(array[safe: 1])
        XCTAssertEqual(array[safe: 1], 1)
        XCTAssertNil(array[safe: 2])
        
        array.removeAll()
        XCTAssertNil(array[safe: 0])
    }
    
}
