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
    var validator: Validator!
    
    override func setUp() {
        super.setUp()
        let entry = Entry()
        entry.type = EntryType.SimpleHTTP
        validator = ValidatorFactory.validator(for: entry)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testValidation() {
        XCTAssertTrue(validator is SimpleHTTPValidator)
        XCTAssertTrue(validator.validateOutput(output: "test"))
    }
}
