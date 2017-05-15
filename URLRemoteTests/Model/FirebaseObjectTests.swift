//
//  FirebaseObjectTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 15/05/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
@testable import URLRemote

class FirebaseObjectTests: XCTestCase {
    var firebaseObject: FirebaseObject!
    
    override func setUp() {
        super.setUp()
        firebaseObject = FirebaseObject(JSONString: "{\r\n\t\"firebaseKey\":\"abcdef\",\r\n\t\"order\":1\r\n}")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFirebaseObjectContents() {
        XCTAssertNotNil(firebaseObject)
        XCTAssertTrue(firebaseObject.firebaseKey == "abcdef")
        XCTAssertTrue(firebaseObject.order == 1)
    }
    
    func testFirebaseComparable() {
        let firebaseObjectOther = FirebaseObject(JSONString: "{\r\n\t\"firebaseKey\":\"ghijkl\",\r\n\t\"order\":2\r\n}")!
        XCTAssertTrue(firebaseObject < firebaseObjectOther)
        XCTAssertFalse(firebaseObject > firebaseObjectOther)
    }
    
    func testFirebaseEquatable() {
        var firebaseObjectOther = FirebaseObject(JSONString: "{\r\n\t\"firebaseKey\":null,\r\n\t\"order\":0\r\n}")!
        XCTAssertFalse(firebaseObjectOther == firebaseObject)
        XCTAssertFalse(firebaseObject == firebaseObjectOther)
        XCTAssertFalse(firebaseObjectOther == firebaseObjectOther)
        XCTAssertTrue(firebaseObject == firebaseObject)
        
        firebaseObjectOther = FirebaseObject(JSONString: "{\r\n\t\"firebaseKey\":\"abcdef\",\r\n\t\"order\":1\r\n}")!
        XCTAssertTrue(firebaseObject == firebaseObjectOther)
    }
}
