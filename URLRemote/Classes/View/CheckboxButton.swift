//
//  CheckboxButton.swift
//  URLRemote
//
//  Created by Michal Švácha on 09/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Bond

///
class CheckboxButton: UIButton {
    ///
    let isChecked = Observable<Bool>(false)

    ///
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.tintColor = .black
        
        _ = self.bnd_tap.observeNext {
            self.isChecked.value = !self.isChecked.value
        }
        
        _ = self.isChecked.observeNext {
            let name = $0 ? "checkbox_selected" : "checkbox_unselected"
            self.setImage(UIImage(named: name), for: .normal)
        }
    }
}
