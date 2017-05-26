//
//  ColorSelectorTests.swift
//  URLRemote
//
//  Created by Michal Švácha on 28/05/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import XCTest
import Material
import Bond
@testable import URLRemote

class ColorSelectorTests: XCTestCase {
    var view: ColorSelectorView?
    
    override func setUp() {
        super.setUp()
        view = ColorSelectorView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        view?.setupViews(with: [.red, .yellow, .green])
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testViewConsistency() {
        let colors = view!.subviews.filter { $0 is FlatButton }
        let overlappingCount = colors.map { color in
            return colors
                .filter { $0 != color }
                .filter { $0.frame.intersects(color.frame) }.count
        }.reduce(0, +)
        XCTAssertEqual(overlappingCount, 0)
    }
    
    func testPublishingSubject() {
        let observable = Observable<ColorName?>(nil)
        XCTAssertNil(observable.value)
        view?.signal.bind(to: observable)
        
        let colors = view!.subviews.filter { $0 is FlatButton }
        XCTAssertTrue(colors.count > 0)
        
        let colorButton = colors[0] as! FlatButton
        colorButton.sendActions(for: .touchUpInside)
        XCTAssertNotNil(observable.value)
    }
}
