//
//  UIViewControllerExtension.swift
//  URLRemote
//
//  Created by Michal Švácha on 09/12/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import Foundation

/// UIViewController extension with utilities used throughout the application.
extension UIViewController {
    
    /// Presents a simple UIAlertController (type .alert) modally in the UIViewController where this method has been called.
    ///
    /// - Parameter header: Text displayed in the header of the dialog.
    /// - Parameter message: Text displayed in the body of the dialog.
    func presentSimpleAlertDialog(header: String, message: String) {
        let ac = UIAlertController(
            title: header,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert)
        ac.addAction(UIAlertAction(
            title: NSLocalizedString("CLOSE", comment: ""),
            style: UIAlertActionStyle.default,
            handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
}
