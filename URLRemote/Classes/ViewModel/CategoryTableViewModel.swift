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

/// View Model of the Category Table View Controller. Handles logic of category selection.
class CategoryTableViewModel {
    let initialSelection = Observable<Int>(0)
    let userSelection = Observable<Int>(0)
    let contents = MutableObservableArray<Category>([])
    
    let signal = PublishSubject<Int, NoError>()
    let bag = DisposeBag()
    
    init() {
        initialSelection.bind(to: userSelection).dispose(in: bag)
    }
    
    /// Validates and saves user's selection in the table view.
    ///
    /// - Parameter index: Selected index by the user.
    func selected(_ index: Int) {
        if let category = contents.array[safe: index], !category.isFull() {
            self.userSelection.value = index
        }
    }
    
    /// Sends out signal with the selection to the observers before the view controller gets dismissed.
    func done() {
        signal.next(userSelection.value)
    }
}
