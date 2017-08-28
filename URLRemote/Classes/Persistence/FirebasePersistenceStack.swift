//
//  FirebasePersistenceStack.swift
//  URLRemote
//
//  Created by Michal Švácha on 25/08/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import ReactiveKit

///
class FirebasePersistenceStack: PersistenceStack {
    var authentication: DataSourceAuthentication
    var dataSource: DataSource?
    var bag = DisposeBag()
    
    init() {
        authentication = FirebaseDataSourceAuthentication()
        authentication
            .dataSource()
            .observeNext { [unowned self] in self.dataSource = $0 }
            .dispose(in: bag)
    }
}
