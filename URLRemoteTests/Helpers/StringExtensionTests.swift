//
//  StringExtensionTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 05/02/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
@testable import URLRemote

class StringExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEmailValidator() {
        ///
    }
    
    /// Success tests - should be acceped as OK urls.
    /// Taken from an amazing blog post: In search of the perfect URL validation regex
    /// Available at https://mathiasbynens.be/demo/url-regex
    ///
    /// - Failing:
    /// 1. http://foo.com/blah_blah_(wikipedia)
    /// 2. http://foo.com/blah_blah_(wikipedia)_(again)
    /// 3. http://✪df.ws/123
    /// 4. http://➡.ws/䨹
    /// 5. http://⌘.ws
    /// 6. http://⌘.ws/
    /// 7. http://foo.com/blah_(wikipedia)#cite-1
    /// 8. http://foo.com/blah_(wikipedia)_blah#cite-1
    /// 9. http://foo.com/unicode_(✪)_in_parens
    /// 10. http://foo.com/(something)?after=parens
    /// 11. http://☺.damowmow.com/
    /// 12. ftp://foo.bar/baz
    /// 13. http://foo.bar/?q=Test%20URL-encoded%20stuff
    /// 14. http://-.~_!$&'()*+,;=:%40:80%2f::::::@example.com
    func testURLValidator() {
        XCTAssertTrue("http://foo.com/blah_blah".isValidURL())
        XCTAssertTrue("http://foo.com/blah_blah/".isValidURL())
        XCTAssertTrue("http://www.example.com/wpstyle/?p=364".isValidURL())
        XCTAssertTrue("https://www.example.com/foo/?bar=baz&inga=42&quux".isValidURL())
        XCTAssertTrue("http://userid:password@example.com:8080".isValidURL())
        XCTAssertTrue("http://userid:password@example.com:8080/".isValidURL())
        XCTAssertTrue("http://userid@example.com".isValidURL())
        XCTAssertTrue("http://userid@example.com/".isValidURL())
        XCTAssertTrue("http://userid@example.com:8080".isValidURL())
        XCTAssertTrue("http://userid@example.com:8080/".isValidURL())
        XCTAssertTrue("http://userid:password@example.com".isValidURL())
        XCTAssertTrue("http://userid:password@example.com/".isValidURL())
        XCTAssertTrue("http://142.42.1.1/".isValidURL())
        XCTAssertTrue("http://142.42.1.1:8080/".isValidURL())
        XCTAssertTrue("http://code.google.com/events/#&product=browser".isValidURL())
        XCTAssertTrue("http://j.mp".isValidURL())
        XCTAssertTrue("http://1337.net".isValidURL())
        XCTAssertTrue("http://a.b-c.de".isValidURL())
        XCTAssertTrue("http://223.255.255.254".isValidURL())
    }
    
    /// Failure tests - should be declined as BAD urls.
    /// Taken from an amazing blog post: In search of the perfect URL validation regex
    /// Available at https://mathiasbynens.be/demo/url-regex
    ///
    /// - Failing:
    /// 1. http://a.b--c.de/
    /// 2. http://-a.b.co
    /// 3. http://a.b-.co
    func testURLValidationFailure() {
        XCTAssertFalse("http://".isValidURL())
        XCTAssertFalse("http://.".isValidURL())
        XCTAssertFalse("http://..".isValidURL())
        XCTAssertFalse("http://../".isValidURL())
        XCTAssertFalse("http://?".isValidURL())
        XCTAssertFalse("http://??".isValidURL())
        XCTAssertFalse("http://??/".isValidURL())
        XCTAssertFalse("http://#".isValidURL())
        XCTAssertFalse("http://##".isValidURL())
        XCTAssertFalse("http://##/".isValidURL())
        XCTAssertFalse("http://foo.bar?q=Spaces should be encoded".isValidURL())
        XCTAssertFalse("//".isValidURL())
        XCTAssertFalse("//a".isValidURL())
        XCTAssertFalse("///a".isValidURL())
        XCTAssertFalse("///".isValidURL())
        XCTAssertFalse("http:///a".isValidURL())
        XCTAssertFalse("foo.com".isValidURL())
        XCTAssertFalse("rdar://1234".isValidURL())
        XCTAssertFalse("h://test".isValidURL())
        XCTAssertFalse("http:// shouldfail.com".isValidURL())
        XCTAssertFalse(":// should fail".isValidURL())
        XCTAssertFalse("http://foo.bar/foo(bar)baz quux".isValidURL())
        XCTAssertFalse("ftps://foo.bar/".isValidURL())
        XCTAssertFalse("http://-error-.invalid/".isValidURL())
        XCTAssertFalse("http://123.123.123".isValidURL())
        XCTAssertFalse("http://3628126748".isValidURL())
        XCTAssertFalse("http://.www.foo.bar/".isValidURL())
        XCTAssertFalse("http://www.foo.bar./".isValidURL())
        XCTAssertFalse("http://.www.foo.bar./".isValidURL())
    }
}
