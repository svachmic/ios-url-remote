//
//  MockDataSourceAuthentication.swift
//  URLRemote
//
//  Created by Michal Švácha on 26/08/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import ReactiveKit
@testable import URLRemote

/// Mocked DataSourceAuthentication object for testing purposes - avoids reads/writes directly in Firebase.
class MockDataSourceAuthentication: DataSourceAuthentication {
    let signal = PublishSubject<DataSource?, NoError>()
    
    func dataSource() -> Signal<DataSource?, NoError> {
        return signal.toSignal()
    }
    
    private func evaluatedUser(email: String, password: String) -> Signal<DataSource, AuthError> {
        if email == "test" && password == "test" {
            let dataSource = MockDataSource()
            signal.next(dataSource)
            return Signal<DataSource, AuthError>.just(dataSource)
        } else {
            signal.next(nil)
            let error = NSError(domain: "", code: 403, userInfo: nil)
            return Signal<DataSource, AuthError>.failed(AuthError.error(error: error))
        }
    }
    
    func createUser(email: String, password: String) -> Signal<DataSource, AuthError> {
        return evaluatedUser(email: email, password: password)
    }
    
    func signIn(email: String, password: String) -> Signal<DataSource, AuthError> {
        return evaluatedUser(email: email, password: password)
    }
    
    func logOut() {
        signal.next(nil)
    }
}
