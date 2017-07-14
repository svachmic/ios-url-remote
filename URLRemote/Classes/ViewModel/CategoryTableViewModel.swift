//
//  CategoryTableViewModel.swift
//  URLRemote
//
//  Created by Michal Švácha on 14/07/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit

///
class CategoryTableViewModel {
    let contents = MutableObservableArray<String>([])
    let signal = PublishSubject<Int, NoError>()
    
    func selected(_ index: Int) {
        self.signal.next(index)
    }
}
