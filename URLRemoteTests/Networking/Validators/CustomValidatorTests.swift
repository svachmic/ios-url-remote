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
    var validator: Validator!
    
    override func setUp() {
        super.setUp()
        let entry = Entry()
        entry.type = EntryType.Custom
        entry.customCriteria = "test"
        validator = ValidatorFactory.validator(for: entry)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testValidation() {
        XCTAssertTrue(validator is CustomCriteriaValidator)
        XCTAssertFalse(validator.validateOutput(output: "unit"))
        XCTAssertTrue(validator.validateOutput(output: "test"))
    }
}
