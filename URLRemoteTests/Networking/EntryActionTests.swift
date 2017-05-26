//
//  EntryActionTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 29/05/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
@testable import URLRemote
@testable import OHHTTPStubs
@testable import Bond

class EntryActionTests: XCTestCase {
    var validator: Validator?
    var successfulStubDescriptor: OHHTTPStubsDescriptor?
    var failureStubDescriptor: OHHTTPStubsDescriptor?
    var totalFailureStubDescriptor: OHHTTPStubsDescriptor?
    var authorizationStubDescriptor: OHHTTPStubsDescriptor?
    
    override func setUp() {
        super.setUp()
        
        let entry = Entry()
        entry.type = EntryType.quido
        validator = ValidatorFactory.validator(for: entry)
        
        successfulStubDescriptor = stub(condition: isScheme("https") && isHost("api.urlremote.com") && isPath("/test_action")) { _ in
            return OHHTTPStubsResponse(
                data: "1".data(using: String.Encoding.utf8)!,
                statusCode: 200,
                headers: ["Content-Type": "text/plain"])
        }
        
        failureStubDescriptor = stub(condition: isScheme("https") && isHost("api.urlremote.com") && isPath("/test_action_failure")) { _ in
            return OHHTTPStubsResponse(
                data: "0".data(using: String.Encoding.utf8)!,
                statusCode: 200,
                headers: ["Content-Type": "text/plain"])
        }
        
        totalFailureStubDescriptor = stub(condition: isScheme("https") && isHost("api.urlremote.com") && isPath("/test_total_failure")) { _ in
            return OHHTTPStubsResponse(
                data: "".data(using: String.Encoding.utf8)!,
                statusCode: 500,
                headers: ["Content-Type": "text/plain"])
        }
        
        authorizationStubDescriptor = stub(condition: isScheme("https") && isHost("api.urlremote.com") && isPath("/test_auth_success") && hasHeaderNamed("Authorization", value: "Basic dXNlcjpwYXNzd29yZA==")) { _ in
            return OHHTTPStubsResponse(
                data: "1".data(using: String.Encoding.utf8)!,
                statusCode: 200,
                headers: ["Content-Type": "text/plain"])
        }
    }
    
    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }
    
    func testFullSuccess() {
        let exp = expectation(description: "Success expectation")
        let observable = Observable<EntryActionStatus?>(nil)
        _ = observable.observeNext { next in
            if let n = next, n == .success {
                exp.fulfill()
            }
        }
        
        EntryAction().signalForAction(
            url: "https://api.urlremote.com/test_action",
            validator: validator!
        ).bind(to: observable)
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testEntryFailure() {
        let exp = expectation(description: "Entry failure expectation")
        let observable = Observable<EntryActionStatus?>(nil)
        _ = observable.observeNext { next in
            if let n = next, n == .failure {
                exp.fulfill()
            }
        }
        
        EntryAction().signalForAction(
            url: "https://api.urlremote.com/test_action_failure",
            validator: validator!
        ).bind(to: observable)
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testTotalFailure() {
        let exp = expectation(description: "Total failure expectation")
        let observable = Observable<EntryActionStatus?>(nil)
        _ = observable.observeNext { next in
            if let n = next, n == .error {
                exp.fulfill()
            }
        }
        
        EntryAction().signalForAction(
            url: "https://api.urlremote.com/test_total_failure",
            validator: validator!
        ).bind(to: observable)
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testAuthSuccess() {
        let exp = expectation(description: "Authorization success expectation")
        let observable = Observable<EntryActionStatus?>(nil)
        _ = observable.observeNext { next in
            if let n = next, n == .success {
                exp.fulfill()
            }
        }
        
        EntryAction().signalForAction(
            url: "https://api.urlremote.com/test_auth_success",
            validator: validator!,
            requiresAuthentication: true,
            user: "user",
            password: "password"
        ).bind(to: observable)
        
        waitForExpectations(timeout: 3, handler: nil)
    }
}
