//
//  CheckboxButton.swift
//  URLRemote
//
//  Created by Michal Švácha on 09/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Bond

/// UIButton subclass with two states (checked/unchecked).
class CheckboxButton: UIButton {
    /// Observable property indicating the state of the button.
    let isChecked = Observable<Bool>(false)

    /// Required initializer for the storyboard
    ///
    /// Sets up the checkbox functionality via bindings.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.tintColor = .black
        
        _ = self.reactive.tap.observeNext {
            self.isChecked.value = !self.isChecked.value
        }
        
        _ = self.isChecked.observeNext {
            let name = $0 ? "checkbox_selected" : "checkbox_unselected"
            self.setImage(UIImage(named: name), for: .normal)
        }
    }
}
