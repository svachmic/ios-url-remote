//
//  File.swift
//  URLRemote
//
//  Created by Michal Švácha on 27/08/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
@testable import URLRemote

///
class MockPersistenceStack: PersistenceStack {
    var authentication: DataSourceAuthentication
    
    init() {
        authentication = MockDataSourceAuthentication()
    }
}
