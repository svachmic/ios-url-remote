//
//  LocalAuthentication+RectiveKit.swift
//  URLRemote
//
//  Created by Michal Švácha on 28/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import LocalAuthentication
import ReactiveKit

/// Enum indicating the status of TouchID Authentication process.
enum AuthenticationStatus {
    
    /// The authentication has been successful.
    case success
    
    /// An error has occurred and the authentication was marked as a failure.
    case failure(error: NSError?)
}

/// Reactive wrapper for TouchID verification.
class TouchIDAuthentication {
    
    /// Returns signal emitting AuthenticationStatus upon completion.
    ///
    /// - Returns: Signal object that is non-disposable.
    func verify() -> Signal<AuthenticationStatus, NoError> {
        let context = LAContext()
        
        return Signal { observer in
            var error: NSError?
            if !context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    observer.completed(with: AuthenticationStatus.failure(error: error))
            } else {
                context.evaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics,
                    localizedReason: NSLocalizedString("TOUCH_ID", comment: ""),
                    reply: { (success, error) -> Void in
                        let result = success ? AuthenticationStatus.success : AuthenticationStatus.failure(error: error as NSError?)
                        observer.completed(with: result)
                })
            }
            
            return NonDisposable.instance
        }
    }
}
