//
//  GenericValidatorTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 15/05/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
@testable import URLRemote

class CustomValidatorTests: XCTestCase {
    var entry: Entry!
    
    override func setUp() {
        super.setUp()
        entry = Entry()
        entry.type = EntryType.custom
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testValidation() {
        entry.customCriteria = "test"
        let validator = ValidatorFactory.validator(for: entry)
        
        XCTAssertTrue(validator is CustomCriteriaValidator)
        XCTAssertFalse(validator.validateOutput(output: "unit"))
        XCTAssertTrue(validator.validateOutput(output: "test"))
    }
    
    func testEmptyValidation() {
        entry.customCriteria = nil
        let emptyValidator = ValidatorFactory.validator(for: entry)
        XCTAssertTrue(emptyValidator is CustomCriteriaValidator)
        XCTAssertFalse(emptyValidator.validateOutput(output: "test"))
        XCTAssertTrue(emptyValidator.validateOutput(output: ""))
    }
}
