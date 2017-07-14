//
//  NotificationRepresentable.swift
//  URLRemote
//
//  Created by Michal Švácha on 14/07/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation

/// Protocol decorating a structure that can serve as a representation of a name of a Notification.
protocol NotificationRepresentable {}

/// Extension enabling raw representation to be converted to NSNotification.Name.
extension NotificationRepresentable where Self: RawRepresentable, Self.RawValue == String {
    
    /// Computed variable based on the rawValue of the item.
    var name: NSNotification.Name {
        return NSNotification.Name(rawValue: self.rawValue)
    }
}
