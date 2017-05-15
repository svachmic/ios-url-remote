//
//  QuidoValidatorTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 15/05/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
@testable import URLRemote

class QuidoValidatorTests: XCTestCase {
    var validator: Validator!
    
    override func setUp() {
        super.setUp()
        let entry = Entry()
        entry.type = EntryType.Quido
        validator = ValidatorFactory.validator(for: entry)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testValidation() {
        XCTAssertTrue(validator is QuidoValidator)
        XCTAssertFalse(validator.validateOutput(output: "0"))
        XCTAssertTrue(validator.validateOutput(output: "1"))
    }
}
