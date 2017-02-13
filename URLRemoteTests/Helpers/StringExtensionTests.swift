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
    
    /// Success tests - should be acceped as OK e-mail addresses.
    /// Taken from a blog post: Email Address test cases
    /// Available at: https://blogs.msdn.microsoft.com/testing123/2009/02/06/email-address-test-cases/
    ///
    /// - Failing:
    /// 1. email@123.123.123.123 // Domain is valid IP address
    /// 2. email@[123.123.123.123] // Square bracket around IP address is considered valid
    /// 3. “email”@domain.com // Quotes around email is considered valid
    func testEmailValidatorSuccess() {
        XCTAssertTrue("email@domain.com".isValidEmail())
        XCTAssertTrue("firstname.lastname@domain.com".isValidEmail())
        XCTAssertTrue("email@subdomain.domain.com".isValidEmail())
        XCTAssertTrue("firstname+lastname@domain.com".isValidEmail())
        XCTAssertTrue("1234567890@domain.com".isValidEmail())
        XCTAssertTrue("email@domain-one.com".isValidEmail())
        XCTAssertTrue("_______@domain.com".isValidEmail())
        XCTAssertTrue("email@domain.name".isValidEmail())
        XCTAssertTrue("email@domain.co.jp".isValidEmail())
        XCTAssertTrue("firstname-lastname@domain.com".isValidEmail())
    }
    
    /// Failure tests - should be declined as BAD e-mail addresses.
    /// Taken from a blog post: Email Address test cases
    /// Available at: https://blogs.msdn.microsoft.com/testing123/2009/02/06/email-address-test-cases/
    ///
    /// - Failing:
    /// 1. Joe Smith <email@domain.com> // Encoded html within email is invalid
    /// 2. email@domain@domain.com // Two @ sign
    /// 3. .email@domain.com // Leading dot in address is not allowed
    /// 4. email.@domain.com // Trailing dot in address is not allowed
    /// 5. email..email@domain.com // Multiple dots
    /// 6. email@domain.com (Joe Smith) // Text followed email is not allowed
    /// 7. email@-domain.com // Leading dash in front of domain is invalid
    /// 8. email@domain..com // Multiple dot in the domain portion is invalid
    func testEmailValidatorFailure() {
        XCTAssertFalse("plainaddress".isValidEmail())
        XCTAssertFalse("#@%^%#$@#$@#.com".isValidEmail())
        XCTAssertFalse("@domain.com".isValidEmail())
        XCTAssertFalse("email.domain.com".isValidEmail())
        XCTAssertFalse("あいうえお@domain.com".isValidEmail())
        XCTAssertFalse("email@domain".isValidEmail())
        XCTAssertFalse("email@111.222.333.44444".isValidEmail())
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
    func testURLValidatorSuccess() {
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
