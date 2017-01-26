//
//  ActionsViewModel.swift
//  URLRemote
//
//  Created by Michal Švácha on 13/12/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import ObjectMapper
import Bond
import ReactiveKit

///
class ActionsViewModel {
    let bndBag = DisposeBag()
    var dataSource: FirebaseDataSource?
    
    init() {
        FIRAuth.auth()?.addStateDidChangeListener { _, user in
            if let user = user {
                print("signed in as \(user.description)")
                
                if let data = self.dataSource, data.user.uid == user.uid {
                    // do nothing
                } else {
                    self.dataSource = FirebaseDataSource(user: user, database: FIRDatabase.database())
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
        
        NotificationCenter.default.bnd_notification(name: NSNotification.Name(rawValue: "CREATED_ENTRY"))
            .observeNext { notification in
                let entry = notification.object as! Entry
                self.dataSource?.write(entry)
            }.dispose(in: self.bndBag)
    }
    
    func logout() {
        self.dataSource = nil
        try? FIRAuth.auth()?.signOut()
    }
    
    func addTestItem() {
        let testEntry = Entry()
        testEntry.name = "test"
        testEntry.color = .green
        testEntry.icon = "lightbulb_on"
        testEntry.url = "https://www.seznam.cz"
        testEntry.type = .SimpleHTTP
        testEntry.requiresAuthentication = false
        self.dataSource?.write(testEntry)
    }
}
