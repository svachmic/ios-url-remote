//
//  TypeViewModel.swift
//  URLRemote
//
//  Created by Michal Švácha on 13/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit

///
class TypeViewModel {
    let contents = ObservableArray<EntryType>(EntryType.allValues)
    
    let signal = PublishSubject<EntryType, NoError>()
    
    func selected(_ index: Int) {
        let item = self.contents[index]
        self.signal.next(item)
    }
}
