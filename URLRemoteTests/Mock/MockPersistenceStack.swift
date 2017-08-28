//
//  File.swift
//  URLRemote
//
//  Created by Michal Švácha on 27/08/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
@testable import URLRemote

/// Mocked PersistenceStack object for depedency injection in testing environment.
class MockPersistenceStack: PersistenceStack {
    var authentication: DataSourceAuthentication
    var dataSource: DataSource?
    
    init() {
        authentication = MockDataSourceAuthentication()
        dataSource = MockDataSource()
    }
}
