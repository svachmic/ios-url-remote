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
        static let entryEdit = "editCell"
        static let categorySelection = "categorySelectionCell"
        static let entryType = "typeCell"
    }
    
    /// Icon names.
    struct Icons {
        struct General {
            static let name = "GENERAL"
            static let items = ["plus", "minus", "on", "off", "house_1", "house_2", "lock_on", "lock_off"]
        }
        
        struct Player {
            static let name = "PLAYER"
            static let items = ["play", "pause", "stop", "rew", "fwd", "previous", "next"]
        }
        
        struct Lights {
            static let name = "LIGHTS"
            static let items = ["lightbulb_on", "lightbulb_off", "day", "night"]
        }
        
        struct Arrows {
            static let name = "ARROWS"
            static let items = ["up", "down", "left", "right", "double_up", "double_down", "double_left", "double_right"]
        }
    }
}
