//
//  DataSource.swift
//  URLRemote
//
//  Created by Michal Švácha on 14/07/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation

///
enum DataSourceNotifications: String, NotificationRepresentable {
    case createdEntry = "CREATED_ENTRY"
}

protocol DataSource {}
