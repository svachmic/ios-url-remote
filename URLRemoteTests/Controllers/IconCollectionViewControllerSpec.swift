//
//  IconCollectionViewControllerSpec.swift
//  URLRemote
//
//  Created by Michal Švácha on 14/09/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import Material
import Bond
import Quick
import Nimble
@testable import URLRemote

class IconCollectionViewControllerSpec: QuickSpec {
    override func spec() {
        var embedder: ToolbarController!
        var subject: IconCollectionViewController!
        
        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            subject = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardID.iconSelection) as! IconCollectionViewController
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
        
        describe("selecting an icon") {
            beforeEach {
                subject.collectionView(subject.collectionView!, didSelectItemAt: IndexPath(row: 2, section: 0))
            }
            
            it("does enable the done button") {
                expect((subject.toolbarController?.toolbar.rightViews[0] as! IconButton).isEnabled).toEventually(beTrue())
            }
        }
        
        describe("selecting an icon and pressing done") {
            let observable = Observable<String?>(nil)
            
            beforeEach {
                subject.viewModel.signal.bind(to: observable)
                subject.collectionView(subject.collectionView!, didSelectItemAt: IndexPath(row: 2, section: 0))
                let button = subject.toolbarController?.toolbar.rightViews[0] as! IconButton
                button.sendActions(for: .touchUpInside)
            }
            
            it("sends value") {
                expect(observable.value).to(equal("on"))
            }
        }
    }
}
