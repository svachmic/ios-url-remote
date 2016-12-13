//
//  AppNavigationController.swift
//  URLRemote
//
//  Created by Michal Švácha on 14/12/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import UIKit
import Material

///
class ApplicationNavigationController: NavigationController {

    ///
    open override func prepare() {
        super.prepare()
        guard let v = navigationBar as? NavigationBar else {
            return
        }
        
        v.depthPreset = .none
        v.dividerColor = Color.grey.lighten3
    }
}
