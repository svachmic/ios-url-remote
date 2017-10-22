//
//  EntrySetupViewControllerSpec.swift
//  URLRemote
//
//  Created by Michal Švácha on 15/09/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import Material
import Bond
import Quick
import Nimble
@testable import URLRemote

class EntrySetupViewControllerSpec: QuickSpec {
    override func spec() {
        var embedder: ToolbarController!
        var subject: EntrySetupViewController!
        
        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            subject = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardID.entrySetup) as! EntrySetupViewController
            let stack = MockPersistenceStack()
            (stack.dataSource as? MockDataSource)?.fillWithTestData()
            subject.stack = stack
            embedder = ToolbarController(rootViewController: subject)
            
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.makeKeyAndVisible()
            window.rootViewController = embedder
            _ = embedder.view
            
            expect(embedder.view).notTo(beNil())
            expect(subject.view).notTo(beNil())
        }
        
        
        it("has cancel button") {
            expect(subject.toolbarController?.toolbar.leftViews.count)
                .to(equal(1))
            expect(subject.toolbarController?.toolbar.leftViews[0]).to(beAnInstanceOf(FlatButton.self))
        }
        
        it("has done button") {
            expect(subject.toolbarController?.toolbar.rightViews.count)
                .to(equal(1))
            expect(subject.toolbarController?.toolbar.rightViews[0]).to(beAnInstanceOf(IconButton.self))
            expect((subject.toolbarController?.toolbar.rightViews[0] as! IconButton).isEnabled).to(beFalse())
        }
        
        
        describe("selecting custom type") {
            beforeEach {
                subject.viewModel.type.value = .custom
            }
            
            it("adds cell to the table view") {
                expect(subject.viewModel.contents.count == 5).toEventually(beTrue())
            }
        }
    }
}

