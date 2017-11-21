//
//  Stylesheet.swift
//  URLRemote
//
//  Created by Michal Švácha on 21/01/2018.
//  Copyright © 2018 Svacha, Michal. All rights reserved.
//

import UIKit
import Material

/// Application stylesheet with style definitions.
enum Stylesheet {
    
    /// General components
    enum General {
        
        /// Any generic flat button
        static let flatButton = Style<FlatButton> {
            $0.titleColor = .white
            $0.pulseColor = .white
            $0.titleLabel?.font = RobotoFont.bold(with: 15)
        }
    }
    
    /// Login screen components
    enum Login {
        
        /// Background table view
        static let tableView = Style<UITableView> {
            $0.backgroundColor = UIColor(named: .gray)
            $0.tableFooterView = UIView(frame: .zero)
            $0.alwaysBounceVertical = false
            $0.alwaysBounceHorizontal = false
            $0.separatorStyle = .none
        }
        
        /// Any TextField used for user input.
        static let textField = Style<TextField> {
            $0.font = RobotoFont.regular(with: 15)
            $0.leftViewMode = .always
            $0.placeholderActiveColor = UIColor(named: .green).darker()
            $0.dividerActiveColor = UIColor(named: .green).darker()
            $0.leftViewActiveColor = UIColor(named: .green).darker()
            $0.isClearIconButtonEnabled = true
            $0.detailColor = UIColor(named: .red)
        }
    }
    
    /// Actions Screen
    enum Actions {
        
        /// Floating button
        static let fabButton = Style<FABButton> {
            $0.tintColor = .white
            $0.pulseColor = .white
            $0.backgroundColor = Color.grey.base
        }
    }
    
    /// Entry setup form components
    enum EntrySetup {
        
        /// Any TextField used for user input.
        static let textField = Style<TextField> {
            $0.autocorrectionType = .no
            $0.font = RobotoFont.regular(with: 13)
            $0.placeholderActiveColor = UIColor(named: .green).darker()
            $0.dividerActiveColor = UIColor(named: .green).darker()
            $0.isClearIconButtonEnabled = true
            $0.detailColor = UIColor(named: .red)
        }
    }
}
