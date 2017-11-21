//
//  UIKit+ReactiveKit.swift
//  URLRemote
//
//  Created by Michal Švácha on 21/11/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit

/// ReactiveKit extension to allow turning events into signals.
extension ReactiveExtensions where Base: UITextField {
    
    /// Emits Bool signal representing the state of the field - empty or not.
    var isEmpty: Signal<Bool, NoError> {
        return base.reactive.text.map {
            guard let text = $0 else { return false }
            return text != ""
        }
    }
}

/// Extension to support bindings
extension UIAlertAction: BindingExecutionContextProvider {
    public var bindingExecutionContext: ExecutionContext {
        return .immediateOnMain
    }
}

/// ReactiveKit extension to allow reactive binding.
extension ReactiveExtensions where Base: UIAlertAction {
    
    /// Binding enabling disabling of action button.
    var enabled: Bond<Bool> {
        return bond { action, isEnabled in
            action.isEnabled = isEnabled
        }
    }
}
