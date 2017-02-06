//
//  StringExtensionTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 05/02/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
@testable import URLRemote

class StringExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEmailValidator() {
        ///
    }
    
    func testURLValidator() {
        XCTAssertTrue("http://www.google.cz".isValidURL())
        XCTAssertTrue("http://www.seznam.cz".isValidURL())
        XCTAssertTrue("http://192.168.0.1:8080".isValidURL())
        XCTAssertTrue("http://192.168.0.1".isValidURL())
        XCTAssertTrue("http://localhost:8080".isValidURL())
        
        XCTAssertFalse("http://www.goog le.com".isValidURL())
    }
}
