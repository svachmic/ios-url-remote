//
//  MaterialFactoryTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 14/09/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
import Material
@testable import URLRemote

class MaterialFactoryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCancelButton() {
        let cancel = MaterialFactory.cancelButton()
        
        XCTAssertEqual(cancel.title, NSLocalizedString("CANCEL", comment: ""))
        XCTAssertEqual(cancel.titleColor, .white)
        XCTAssertEqual(cancel.pulseColor, .white)
        XCTAssertEqual(cancel.titleLabel?.font, RobotoFont.bold(with: 15))
    }
    
    func testDoneButton() {
        let done = MaterialFactory.doneButton()
        
        XCTAssertEqual(done.image, Icon.cm.check)
        XCTAssertEqual(done.pulseColor, .white)
    }
    
}
