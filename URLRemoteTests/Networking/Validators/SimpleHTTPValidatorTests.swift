//
//  SimpleHTTPValidatorTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 15/05/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
@testable import URLRemote

class SimpleHTTPValidatorTests: XCTestCase {
    let entry = Entry()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testValidation() {
        entry.type = EntryType.simpleHTTP
        let validator = ValidatorFactory.validator(for: entry)
        
        XCTAssertTrue(validator is SimpleHTTPValidator)
        XCTAssertTrue(validator.validateOutput(output: "test"))
    }
    
    func testNilEntryType() {
        entry.type = nil
        let validator = ValidatorFactory.validator(for: entry)
        
        XCTAssertTrue(validator is SimpleHTTPValidator)
        XCTAssertTrue(validator.validateOutput(output: "test"))
    }
}
