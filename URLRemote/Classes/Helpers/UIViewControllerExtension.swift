//
//  UIViewControllerExtension.swift
//  URLRemote
//
//  Created by Michal Švácha on 09/12/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import Foundation
import UIKit

/// UIViewController extension with utilities used throughout the application.
extension UIViewController {
    
    /// Presents a simple UIAlertController (type .alert) modally in the UIViewController where this method has been called.
    ///
    /// - Parameter header: Text displayed in the header of the dialog.
    /// - Parameter message: Text displayed in the body of the dialog.
    func presentSimpleAlertDialog(header: String, message: String) {
        let alertDialog = AlertDialogBuilder
            .dialog(title: header, text: message, localized: true)
            .closeAction()
        self.present(alertDialog, animated: true, completion: nil)
    }
}
