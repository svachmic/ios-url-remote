//
//  RaisedButton+Bond.swift
//  URLRemote
//
//  Created by Michal Švácha on 16/12/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import Foundation
import ReactiveKit
import Alamofire

/// Enum indicating the status of the performed action.
enum EntryActionStatus {
    
    /// The action was performed and validated as a success.
    case success
    
    /// The action was performed but the Validator evaluated the ouput as a failure.
    case failure
    
    // An error has occurred - either network or device problem.
    case error
}

/// Encapsulation for Entry actions.
class EntryAction {
    
    /// Creates a signal with the end result of the action.
    ///
    /// - Parameter url: URL of the desired action.
    /// - Parameter validator: A Validator that will evaluate the output.
    /// - Parameter requiresAuthentication: Boolean flag indicating whether or not this action requires a HTTP Authentication.
    /// - Parameter user: Username for HTTP Authentication.
    /// - Parameter password: Password for HTTP Authentication.
    /// - Returns: Signal emitting EntryActionStatus and no errors.
    func signalForAction(url: String, validator: Validator, requiresAuthentication: Bool = false, user: String? = nil, password: String? = nil) -> Signal<EntryActionStatus, NoError> {
        return Signal { observer in
            var request = Alamofire.request(url, method: HTTPMethod.get)
            
            if let user = user, let password = password, requiresAuthentication {
                let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
                let base64Credentials = credentialData.base64EncodedString(options: [])
                request = Alamofire.request(url,
                    method: HTTPMethod.get,
                    parameters: nil,
                    encoding: URLEncoding.default,
                    headers: ["Authorization": "Basic \(base64Credentials)"])
            }
            
            request.validate(statusCode: 200..<300).responseString { response in
                switch response.result {
                case .success(let value):
                    let validated = validator.validateOutput(output: value)
                    observer.completed(with: validated ? .success : .failure)
                    break
                case .failure:
                    observer.completed(with: .error)
                    break
                }
            }
            
            return NonDisposable.instance
        }
    }
}
