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
    var name = Observable<String>("")
    var color = Observable<ColorName>(.yellow)
    var icon = Observable<String>("lightbulb_on")
    var url = Observable<String>("")
    var type = Observable<EntryType>(.SimpleHTTP)
    var requiresAuthentication = Observable<Bool>(false)
    var login = Observable<String?>(nil)
    var password = Observable<String?>(nil)
    
    // Table
    let contents = MutableObservableArray<EntrySetupTableCell>([
        EntrySetupTableCell(
            identifier: "designCell",
            height: 133.0),
        EntrySetupTableCell(
            identifier: "typeCell",
            height: 68.0),
        EntrySetupTableCell(
            identifier: "actionCell",
            height: 228.0)
        ])
    
    func toEntry() -> Entry {
        let entry = Entry()
        //entry.name = self.name.value
        entry.color = self.color.value
        entry.icon = self.icon.value
        entry.url = self.url.value
        entry.type = self.type.value
        return entry
    }
}
