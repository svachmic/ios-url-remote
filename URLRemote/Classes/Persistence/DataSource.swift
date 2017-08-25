//
//  DataSource.swift
//  URLRemote
//
//  Created by Michal Švácha on 14/07/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import ReactiveKit

///
enum DataSourceNotifications: String, NotificationRepresentable {
    case createdEntry = "CREATED_ENTRY"
}

///
enum AuthError: Error {
    case error(error: Error?)
}

protocol DataSourceAuthentication {
    
    ///
    func dataSourceSignal() -> Signal<DataSource?, NoError>
    
    ///
    func createUser(email: String, password: String) -> Signal<DataSource, AuthError>
    
    ///
    func signIn(email: String, password: String) -> Signal<DataSource, AuthError>
    
    ///
    func logOut()
}

protocol DataSource {
    
    /// rename to categories
    func categoriesSignal() -> Signal<[Category], NoError>
    
    /// rename to entries
    func entriesSignal() -> Signal<[Entry], NoError>
    
    /// rename to update
    func write(_ category: Category)
    
    ///
    func delete(_ category: Category)
    
    ///
    func move(entry: Entry, from: Category, to: Category, shuffleOrder: Bool)
    
    /// rename to update
    func write(_ entry: Entry)
    
    /// rename to add to:
    func write(entry: Entry, category: Category)
    
    ///
    func delete(_ entry: Entry)
    
    ///
    //func delete(entry: Entry, from category: Category)
}
