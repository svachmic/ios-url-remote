//
//  CategoryTableViewControllerSpec.swift
//  URLRemote
//
//  Created by Michal Švácha on 08/09/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import Material
import Quick
import Nimble
@testable import URLRemote

class CategoryTableViewControllerSpec: QuickSpec {
    
    override func spec() {
        var embedder: ToolbarController!
        var subject: CategoryTableViewController!
        let dataSource = MockDataSource()
        dataSource.fillWithTestData()
        
        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            subject = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardID.categorySelection) as! CategoryTableViewController
            embedder = ToolbarController(rootViewController: subject)
            
            dataSource.categories().observeNext {
                subject.viewModel.contents.replace(with: $0, performDiff: true)
            }.dispose(in: subject.bag)
            
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
        
        describe("selecting an invalid row") {
            beforeEach {
                subject.tableView(subject.tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
            }
            
            it("doesn't enable the done button") {
                expect((subject.toolbarController?.toolbar.rightViews[0] as! IconButton).isEnabled).toEventually(beFalse())
            }
        }
        
        describe("selecting a valid row") {
            beforeEach {
                subject.tableView(subject.tableView, didSelectRowAt: IndexPath(row: 2, section: 0))
            }
            
            it("enables the done button") {
                expect((subject.toolbarController?.toolbar.rightViews[0] as! IconButton).isEnabled).toEventually(beTrue())
            }
        }
    }
}
