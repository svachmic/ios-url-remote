//
//  LoginViewModelTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 15/05/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
@testable import URLRemote

class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTransformationConsistency() {
        XCTAssertTrue(viewModel.state == .signIn)
        XCTAssertTrue(viewModel.contents.count == 7)
        
        viewModel.transform()
        XCTAssertTrue(viewModel.state == .signUp)
        XCTAssertTrue(viewModel.contents.count == 8)
        
        viewModel.transform()
        XCTAssertTrue(viewModel.state == .signIn)
        XCTAssertTrue(viewModel.contents.count == 7)
    }
}
