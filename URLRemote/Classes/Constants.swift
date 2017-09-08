//
//  Constants.swift
//  URLRemote
//
//  Created by Michal Švácha on 18/07/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation

/// Constants used throughout the whole application.
struct Constants {
    
    /// Storyboard IDs for view controllers.
    struct StoryboardID {
        static let login = "loginController"
        static let categoryEdit = "categoryEditViewConroller"
        static let entrySetup = "entrySetupController"
        static let iconSelection = "iconController"
        static let typeSelection = "typeController"
        static let categorySelection = "categoryTableController"
    }
    
    /// Collection view cells' IDs.
    struct CollectionViewCell {
        static let header = "headerCell"
        static let entry = "entryCell"
    }
    
    /// Table view cells' IDs.
    struct TableViewCell {
        static let entryEdit = "editCell"
        static let categorySelection = "categorySelectionCell"
        static let entryType = "typeCell"
    }
}
