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

///
enum EntryActionStatus {
    case success
    case failure
    case error
}

///
class EntryAction {
    
    ///
    ///
    /// - Parameter url: ...
    /// - Returns: ...
    func signalForAction(url: String, validator: Validator, requiresAuthentication: Bool = false, user: String? = nil, password: String? = nil) -> Signal<EntryActionStatus, NoError> {
        return Signal { observer in
            var request = Alamofire.request(url, method: HTTPMethod.get)
            
            if let user = user, let password = password, requiresAuthentication {
                request = request.authenticate(user: user, password: password)
            }
            
            request.responseString { response in
                switch response.result {
                case .success(let value):
                    let validated = validator.validateOutput(output: value)
                    observer.completed(with: validated ? .success : .failure)
                    break
                case .failure(_):
                    observer.completed(with: .failure)
                    break
                }
            }
            
            return NonDisposable.instance
        }
    }
}
