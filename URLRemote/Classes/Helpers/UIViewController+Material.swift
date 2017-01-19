//
//  UIViewController+Material.swift
//  URLRemote
//
//  Created by Michal Švácha on 19/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import Material

/// UIViewController extension with Material related utilities used throughout the application.
extension UIViewController {
    
    /// Embeds the UIViewController in a ToolbarController and presents it modally in the current parental viewController.
    ///
    /// - Parameter viewController: The UIViewController to be embedded in the ToolbarController.
    /// - Parameter barTintColor: The color of the Toolbar. Darker color (automatically generated) will be applied on the statusBar. 
    func presentEmbedded(viewController: UIViewController, barTintColor: UIColor) {
        let toolbarController = ToolbarController(rootViewController: viewController)
        toolbarController.statusBarStyle = .lightContent
        toolbarController.statusBar.backgroundColor = barTintColor.darker()
        toolbarController.toolbar.backgroundColor = barTintColor
        self.parent?.present(toolbarController, animated: true, completion: nil)
    }
}
