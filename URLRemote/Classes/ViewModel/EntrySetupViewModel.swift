//
//  EntrySetupViewModel.swift
//  URLRemote
//
//  Created by Michal Švácha on 04/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import Bond

///
struct EntrySetupTableCell {
    let identifier: String
    let height: CGFloat
}

///
class EntrySetupViewModel {
    var color = Observable<ColorName>(.green)
    var icon = Observable<String>("")
    var url = Observable<String>("")
    var type = Observable<EntryType>(.SimpleHTTP)
    var requiresAuthentication = Observable<Bool>(false)
    var login = Observable<String?>(nil)
    var password = Observable<String?>(nil)
    
    func toEntry() -> Entry {
        let entry = Entry()
        entry.color = self.color.value
        entry.icon = self.icon.value
        entry.url = self.url.value
        entry.type = self.type.value
        return entry
    }
}
