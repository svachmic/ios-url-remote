//
//  TypeTableViewControllerSpec.swift
//  URLRemoteTests
//
//  Created by Michal Švácha on 23/10/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import Material
import Quick
import Nimble
@testable import URLRemote

class TypeTableViewControllerSpec: QuickSpec {
    
    override func spec() {
        var embedder: ToolbarController!
        var subject: TypeTableViewController!
        let dataSource = MockDataSource()
        dataSource.fillWithTestData()
        
        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            subject = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardID.typeSelection) as! TypeTableViewController
            embedder = ToolbarController(rootViewController: subject)
            
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.makeKeyAndVisible()
            
            let root = ToolbarController(rootViewController: UIViewController())
            window.rootViewController = root
            root.present(embedder, animated: false, completion: nil)
            _ = embedder.view
            
            expect(embedder.view).notTo(beNil())
            expect(subject.view).notTo(beNil())
        }
        
        it("has cancel button") {
            expect(subject.toolbarController?.toolbar.leftViews.count)
                .to(equal(1))
            expect(subject.toolbarController?.toolbar.leftViews[0]).to(beAnInstanceOf(FlatButton.self))
        }
        
        describe("selecting a valid row") {
            beforeEach {
                subject.tableView(subject.tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
            }
            
            it("dismisses the controller") {
                expect(subject.isBeingPresented).toEventually(beFalse())
            }
        }
    }
}
