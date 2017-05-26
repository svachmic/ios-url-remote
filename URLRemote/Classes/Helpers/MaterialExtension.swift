//
//  MaterialExtension.swift
//  URLRemote
//
//  Created by Michal Švácha on 29/05/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import Material

extension FABMenu {
    
    /// Toggles the menu open/close.
    func toggle() {
        var angle: CGFloat = 0.0
        
        if self.isOpened {
            self.close()
            for v in self.subviews {
                (v as? FABMenuItem)?.hideTitleLabel()
            }
        } else {
            angle = 45.0
            self.open()
            for v in self.subviews {
                (v as? FABMenuItem)?.showTitleLabel()
            }
        }
        
        self.subviews.first?.motion(.rotationAngle(angle), .duration(0.1))
    }
}
