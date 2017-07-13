//
//  ActionsViewModel.swift
//  URLRemote
//
//  Created by Michal Švácha on 13/12/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import Foundation
import FirebaseAuth
import ObjectMapper
import Bond
import ReactiveKit

///
class ActionsViewModel {
    let bndBag = DisposeBag()
    var dataSource: FirebaseDataSource?
    var data = MutableObservable2DArray<Category, Entry>([])
    
    init() {
        Auth.auth().addStateDidChangeListener { _, user in
            if let user = user {
                print("signed in as \(user.description)")
                
                if let data = self.dataSource, data.user.uid == user.uid {
                    // do nothing
                } else {
                    self.dataSource = FirebaseDataSource(user: user)
                    NotificationCenter.default.post(
                        name: NSNotification.Name(rawValue: "USER_LOGGED_IN"),
                        object: nil)
                }
            } else {
                NotificationCenter.default.post(
                    name: NSNotification.Name(rawValue: "USER_LOGGED_OUT"),
                    object: nil)
            }
        }
        
        NotificationCenter.default.reactive.notification(name: NSNotification.Name(rawValue: "CREATED_ENTRY"))
            .observeNext { notification in
                let entry = notification.object as! Entry
                self.dataSource?.write(entry)
            }.dispose(in: self.bndBag)
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
    
    func bindDataSource() {
        guard let dataSource = dataSource else {
            return
        }
        
        _ = combineLatest(dataSource.categoriesSignal(), dataSource.entriesSignal()) { (categories, entries) -> MutableObservable2DArray<Category, Entry> in
            let contents = MutableObservable2DArray<Category, Entry>([])
            
            for category in categories {
                let section = Observable2DArraySection<Category, Entry>(
                    metadata: category,
                    items: entries.filter { category.entryKeys.contains($0.firebaseKey!) }
                )
                contents.appendSection(section)
            }
            
            return contents
            }.observeNext {
                self.data.replace(with: $0, performDiff: true)
        }.dispose(in: bndBag)
    }
    
    func addTestItem() {
        let testEntry = Entry()
        testEntry.name = "test"
        testEntry.color = .green
        testEntry.icon = "lightbulb_on"
        testEntry.url = "https://www.seznam.cz"
        testEntry.type = .simpleHTTP
        testEntry.requiresAuthentication = false
        self.dataSource?.write(testEntry)
    }
}
