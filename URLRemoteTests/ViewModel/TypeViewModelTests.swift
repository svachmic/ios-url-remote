//
//  TypeViewModelTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 15/05/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
@testable import URLRemote
@testable import Bond

class TypeViewModelTests: XCTestCase {
    var viewModel: TypeViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = TypeViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPublishingSubject() {
        let observable = Observable<EntryType?>(nil)
        XCTAssertNil(observable.value)
        viewModel.signal.bind(to: observable)
        
        viewModel.selected(0)
        XCTAssertTrue(observable.value == EntryType.custom)
        
        viewModel.selected(1)
        XCTAssertTrue(observable.value == EntryType.simpleHTTP)
        
        viewModel.selected(2)
        XCTAssertTrue(observable.value == EntryType.quido)
    }
}
