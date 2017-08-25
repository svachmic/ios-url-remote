//
//  FirebasePersistenceStack.swift
//  URLRemote
//
//  Created by Michal Švácha on 25/08/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation

///
class FirebasePersistenceStack: PersistenceStack {
    var authentication: DataSourceAuthentication
    
    init() {
        authentication = FirebaseDataSourceAuthentication()
    }
}
