//
//  LoginViewModelTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 15/05/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
import Bond
@testable import URLRemote

class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel(authentication: MockDataSourceAuthentication())
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
    
    func testFailedSignUp() {
        let signObs = Observable<DataSource?>(nil)
        viewModel.dataSource.bind(to: signObs)
        
        viewModel.email.value = nil
        viewModel.password.value = nil
        viewModel.signUp()
        
        XCTAssertNil(signObs.value)
    }
    
    func testErroredSignUp() {
        let signObs = Observable<DataSource?>(nil)
        viewModel.dataSource.bind(to: signObs)
        let error = Observable<AuthError?>(nil)
        viewModel.errors.bind(to: error)
        
        viewModel.email.value = "wrong"
        viewModel.password.value = "wrong"
        viewModel.signUp()
        
        XCTAssertNil(signObs.value)
        XCTAssertNotNil(error.value)
    }
    
    func testSignUp() {
        let signObs = Observable<DataSource?>(nil)
        viewModel.dataSource.bind(to: signObs)
        
        viewModel.email.value = "test"
        viewModel.password.value = "test"
        viewModel.signUp()
        
        XCTAssertNotNil(signObs.value)
    }
    
    func testFailedSignIn() {
        let signObs = Observable<DataSource?>(nil)
        viewModel.dataSource.bind(to: signObs)
        
        viewModel.email.value = nil
        viewModel.password.value = nil
        viewModel.signIn()
        
        XCTAssertNil(signObs.value)
    }
    
    func testErroredSignIn() {
        let signObs = Observable<DataSource?>(nil)
        viewModel.dataSource.bind(to: signObs)
        let error = Observable<AuthError?>(nil)
        viewModel.errors.bind(to: error)
        
        viewModel.email.value = "wrong"
        viewModel.password.value = "wrong"
        viewModel.signUp()
        
        XCTAssertNil(signObs.value)
        XCTAssertNotNil(error.value)
    }
    
    func testSignIn() {
        let signObs = Observable<DataSource?>(nil)
        viewModel.dataSource.bind(to: signObs)
        
        viewModel.email.value = "test"
        viewModel.password.value = "test"
        viewModel.signIn()
        
        XCTAssertNotNil(signObs.value)
    }
}
