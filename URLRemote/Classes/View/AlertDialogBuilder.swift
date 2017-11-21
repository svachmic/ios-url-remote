//
//  AlertDialogBuilder.swift
//  URLRemote
//
//  Created by Michal Švácha on 21/01/2018.
//  Copyright © 2018 Svacha, Michal. All rights reserved.
//

import UIKit

/// Builder class for easier building of Alert Dialogs.
class AlertDialogBuilder {
    
    /// Builds an alert controller as a dialog and returns it.
    ///
    /// - Parameter title: Title for the dialog.
    /// - Parameter text: Text for the dialog.
    /// - Parameter localized: Flag indicating whether or not the supplied strings are already localized.
    /// - Returns: UIAlertController built as an alert dialog with preset values.
    class func dialog(title: String, text: String, localized: Bool = false) -> UIAlertController {
        return UIAlertController(
            title: localized ? title : NSLocalizedString(title, comment: ""),
            message: localized ? text : NSLocalizedString(text, comment: ""),
            preferredStyle: .alert)
    }
}

/// Extension for UIAlertController for easier building.
extension UIAlertController {
    
    /// Adds an action and returns the UIAlertController to enable chaining.
    ///
    /// - Parameter title: Title to be localized and set.
    /// - Parameter style: Style of the action.
    /// - Parameter handler: Handler to be called upon tap.
    /// - Returns: The Alert Controller itself to enable chaining.
    private func addAction(title: String, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        addAction(UIAlertAction(
            title: NSLocalizedString(title, comment: ""),
            style: style,
            handler: handler))
        return self
    }
    
    /// Adds a destructive action to the dialog.
    ///
    /// - Parameter title: Title to be localized and set for the action.
    /// - Parameter handler: Handler to be called upon tap.
    /// - Returns: The Alert Controller itself to enable chaining.
    func destructiveAction(title: String, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        return addAction(title: title,
                  style: .destructive,
                  handler: handler)
    }
    
    /// Adds close action to the dialog.
    ///
    /// - Parameter handler: Handler to be called upon tap.
    /// - Returns: The Alert Controller itself to enable chaining.
    func closeAction(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        return addAction(title: "CLOSE",
                  style: .default,
                  handler: handler)
    }
    
    /// Adds cancel action to the dialog.
    ///
    /// - Parameter handler: Handler to be called upon tap.
    /// - Returns: The Alert Controller itself to enable chaining.
    func cancelAction(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        return destructiveAction(title: "CANCEL", handler: handler)
    }
}
