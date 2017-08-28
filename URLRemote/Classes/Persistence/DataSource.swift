//
//  DataSource.swift
//  URLRemote
//
//  Created by Michal Švácha on 14/07/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import ReactiveKit

/// Wrapper error for error distribution in ReactiveKit Signals.
enum AuthError: Error {
    case error(error: Error?)
}

/// Data source authentication protocol encapsulating underlying authentication lyer for sign in/up operations.
protocol DataSourceAuthentication {
    
    /// Returns signal with appropriately logged in DataSource object in the stream.
    ///
    /// - Returns: Non-erroring signal emitting optional DataSource object. Nil when the user is logged out.
    func dataSource() -> Signal<DataSource?, NoError>
    
    /// Creates a new user in the persistence layer and loggs the user in.
    ///
    /// - Parameter email: E-mail of the user.
    /// - Parameter password: Password of the user.
    /// - Returns: Signal emitting DataSource object bound to the user. Emits AuthError on error.
    func createUser(email: String, password: String) -> Signal<DataSource, AuthError>
    
    /// Logs the user in with the given credentials.
    ///
    /// - Parameter email: E-mail of the user.
    /// - Parameter password: Password of the user.
    /// - Returns: Signal emitting DataSource object bound to the user. Emits AuthError on error.
    func signIn(email: String, password: String) -> Signal<DataSource, AuthError>
    
    /// Logs the user out.
    func logOut()
}

/// Data source protocol encapsulating underlying persistence layer for CRUD operations.
protocol DataSource: class {
    
    // MARK: - Read -
    
    /// Returns a signal with categories from the underlying database structure.
    ///
    /// - Returns: Non-erroring signal with an array of categories.
    func categories() -> Signal<[Category], NoError>
    
    /// Returns a signal with entries from the underlying database structure.
    ///
    /// - Returns: Non-erroring signal with an array of entries.
    func entries() -> Signal<[Entry], NoError>
    
    /// Returns a signal with entries under a given category from the underlying database structure.
    ///
    /// - Parameter category: Category containing returned entries.
    /// - Returns: Non-erroring signal with an array of entries belonging to the given category.
    func entries(under category: Category) -> Signal<[Entry], NoError>
    
    // MARK: - Write -
    
    /// Performs writing operation. If the category does not exist a new one is created. Otherwise the old one is updated.
    ///
    /// - Parameter category: Category to be written in the database.
    func update(_ category: Category)
    
    // TODO: Should it be handled?
    /// Deletes category from the database. Doesn't handle underlying entries.
    ///
    /// - Parameter category: Category to be deleted.
    func delete(_ category: Category)
    
    /// Performs writing operation. If the entry does not exist a new one is created. Otherwise the old one is updated.
    ///
    /// - Parameter entry: Entry to be written in the database.
    func update(_ entry: Entry)
    
    /// Performs batch writing operation. If any entry does not exist a new one is created.
    ///
    /// - Parameter entries: Entries to be written in the database.
    func update(batch entries: [Entry])
    
    /// Adds the entry to the category and persists all changes. If neither of them exist, they are created.
    ///
    /// - Parameter entry: Entry to be persisted and added to the given category.
    /// - Parameter category: Category to be persisted holding the given entry.
    func add(_ entry: Entry, to category: Category)
    
    /// Moves entry from given source category to the other given category.
    ///
    /// - Parameter entry: Entry to be moved.
    /// - Parameter fromCategory: Category that currently owns the entry.
    /// - Parameter toCategory: Category that will own the entry after this method gets performed.
    func move(_ entry: Entry, from fromCategory: Category, to toCategory: Category)
    
    /// Deletes entry from the database. Doesn't handle belonging to a category.
    ///
    /// - Parameter entry: Entry to be deleted.
    func delete(_ entry: Entry)
    
    /// Deletes entry from the persistence layer and also removes it from the given category.
    ///
    /// - Parameter entry: Entry to be deleted.
    /// - Parameter category: Category from which the entry should be also removed.
    func delete(entry: Entry, from category: Category)
}

/// Extension implementing features on top of basic methods provided by the protocol.
extension DataSource {
    
    // MARK: - Private functions
    
    /// Reindexes all entries under given category. Takes all entries sorted and assigns them their position in linear fashion.
    ///
    /// - Parameter category: Category under which the entries should be reindexed.
    private func reindexEntries(under category: Category) {
        _ = self.entries(under: category).take(first: 1).observeNext { [unowned self] in
            var entries = $0
            for index in 0..<entries.count {
                let entry = entries[index]
                entry.order = index
            }
            
            self.update(batch: entries)
        }
    }
    
    // MARK: - Public functions
    
    /// Filters out category and then entries. Wraps them in a signal and returns.
    func entries(under category: Category) -> Signal<[Entry], NoError> {
        let categoriesFiltered = categories()
            .filter { $0 == category }
        return combineLatest(categoriesFiltered, entries()) { (categories, entries) -> [Entry] in
            if let cat = categories.dataSource.array[safe: 0] {
                return entries.filter { cat.contains(entry: $0) }
            }
            
            return []
        }
    }
    
    /// Removes the entry from the first category and then reindexes it. After that adds the entry to the second category. That way the signals don't clash.
    func move(_ entry: Entry, from fromCategory: Category, to toCategory: Category) {
        fromCategory.remove(entry: entry)
        self.update(fromCategory)
        self.reindexEntries(under: fromCategory)
        
        toCategory.add(entry: entry)
        self.update(entry)
        self.update(toCategory)
    }
    
    /// Performs update on each of the entries in the array.
    func update(batch entries: [Entry]) {
        for entry in entries {
            self.update(entry)
        }
    }
    
    /// First adds the entry to the category, updating its order. and then performs update.
    func add(_ entry: Entry, to category: Category) {
        // has to be performed before to assure existence of foreign keys
        self.update(entry)
        category.add(entry: entry)
        
        // has to be also performed after because category modifies the order field
        self.update(entry)
        self.update(category)
    }
    
    /// First removes the entry from the category, then updates the category and then deletes the entry.
    func delete(entry: Entry, from category: Category) {
        category.remove(entry: entry)
        self.update(category)
        self.delete(entry)
    }
}
