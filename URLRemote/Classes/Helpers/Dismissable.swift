//
//  Dismissable.swift
//  URLRemote
//
//  Created by Michal Švácha on 22/01/2018.
//  Copyright © 2018 Svacha, Michal. All rights reserved.
//

import UIKit
import Bond
import Material

/// Protocol for any object that has a dismiss functionality.
protocol Dismissable {}

/// Style for buttons used for dismiss action.
enum DismissableButtonStyle {
    
    /// Dismissal with closing current context.
    case close
    
    /// Dismissal with cancelling current activities.
    case cancel
}

/// Extension for enabling dismissal functions on UIViewController objects.
extension Dismissable where Self: UIViewController {
    
    /// Sets up dimissi button in the toolbar.
    ///
    /// - Parameter style: Style of the dismiss button.
    func setupDismissButton(with style: DismissableButtonStyle) {
        let button: FlatButton
        switch style {
        case .close:
            button = MaterialFactory.closeButton()
        case .cancel:
            button = MaterialFactory.cancelButton()
        }
        
        button.reactive.tap.observeNext { [weak self] in
            self?.parent?.dismiss(animated: true, completion: nil)
        }.dispose(in: bag)
        
        toolbarController?.toolbar.leftViews = [button]
    }
}
