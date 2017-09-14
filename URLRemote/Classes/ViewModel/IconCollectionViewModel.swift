//
//  IconCollectionViewModel.swift
//  URLRemote
//
//  Created by Michal Švácha on 10/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond

/// View Model of the Icon Collection View Controller. Handles logic of icon selection.
class IconCollectionViewModel {
    var initialSelection = Observable<IndexPath?>(nil)
    var userSelection = Observable<IndexPath?>(nil)
    let contents = MutableObservable2DArray<String, String>([])
    
    let signal = PublishSubject<String, NoError>()
    let bag = DisposeBag()
    
    var iconColor = UIColor.gray
    
    /// Initializes contents with sets of icons. Also sets up selection binding.
    init() {
        contents.appendSection(generateSection(name: Constants.Icons.General.name, items: Constants.Icons.General.items))
        contents.appendSection(generateSection(name: Constants.Icons.Player.name, items: Constants.Icons.Player.items))
        contents.appendSection(generateSection(name: Constants.Icons.Lights.name, items: Constants.Icons.Lights.items))
        contents.appendSection(generateSection(name: Constants.Icons.Arrows.name, items: Constants.Icons.Arrows.items))
        
        initialSelection.bind(to: userSelection).dispose(in: bag)
    }
    
    /// Sets the initial value of the icon by finding its indeces.
    ///
    /// - Parameter value: Name of the icon.
    func setInitial(value: String) {
        initialSelection.value = self.find(value)
    }
    
    /// Emits the selected icon through the signal. Fails silently.
    func done() {
        if let indexPath = userSelection.value {
            let icon = contents[indexPath.section].items[indexPath.row]
            signal.next(icon)
        }
    }
    
    /// MARK: - Helper functions
    
    /// Generates a section of icons based on given values.
    ///
    /// - Parameter name: Name of the section.
    /// - Parameter items: Contents of the section.
    /// - Returns: Pre-filled section of icon names.
    private func generateSection(name: String, items: [String]) -> Observable2DArraySection<String, String> {
        return Observable2DArraySection<String, String>(
            metadata: NSLocalizedString(name, comment: ""),
            items: items
        )
    }
    
    /// Finds given value in the contents array. Returns (0, 0) if not found.
    ///
    /// - Parameter value: Name of the icon to be found.
    /// - Returns: IndexPath object with indices of the icon.
    private func find(_ value: String) -> IndexPath {
        for i in 0..<self.contents.sections.count {
            for j in 0..<self.contents[i].items.count {
                let item = self.contents[i].items[j]
                if value == item {
                    return IndexPath(row: j, section: i)
                }
            }
        }
        
        return IndexPath(row: 0, section: 0)
    }
}
