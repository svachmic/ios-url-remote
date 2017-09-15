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
        
        // MARK: - Action Controller
        
        static let header = "headerCell"
        static let entry = "entryCell"
        
        // MARK: - Icon Controller
        
        static let iconsSection = "iconHeaderCell"
        static let iconCell = "iconCell"
    }
    
    /// Table view cells' IDs.
    struct TableViewCell {
        
        // MARK: - Entry Setup Controller
        
        static let design = "designCell"
        static let genericButton = "genericButtonCell"
        static let action = "actionCell"
        static let criteria = "criteriaCell"
        
        // MARK: - Category Selection
        
        static let entryEdit = "editCell"
        static let categorySelection = "categorySelectionCell"
        
        // MARK: - Type Controller
        
        static let entryType = "typeCell"
    }
    
    /// Icons.
    struct Icons {
        static let General = IconProvider(
            name: "GENERAL",
            items: ["plus", "minus", "on", "off", "house_1", "house_2", "lock_on", "lock_off"]
        )
        
        static let Player = IconProvider(
            name: "PLAYER",
            items: ["play", "pause", "stop", "rew", "fwd", "previous", "next"]
        )
        
        static let Lights = IconProvider(
            name: "LIGHTS",
            items: ["lightbulb_on", "lightbulb_off", "day", "night"]
        )
        
        static let Arrows = IconProvider(
            name: "ARROWS",
            items: ["up", "down", "left", "right", "double_up", "double_down", "double_left", "double_right"]
        )
    }
}

/// Wrapper struct for all icon related constants.
struct IconProvider {
    
    /// Section name for the set of icons.
    let name: String
    
    /// Icon names.
    let items: [String]
}
