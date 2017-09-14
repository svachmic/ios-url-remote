//
//  MaterialExtension.swift
//  URLRemote
//
//  Created by Michal Švácha on 29/05/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import Material

/// Extension for FABMenu used for adding categories and entries.
extension FABMenu {
    
    /// Toggles the menu open/close with an animation.
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
        
        let animations: [MotionAnimation] = [.rotate(angle), .duration(0.1)]
        self.subviews.first?.animate(animations)
    }
}

/// Factory class that generates Material UI componenets used in the application.
class MaterialFactory {
    
    /// Generates a cancel button used in ToolbarController as a left view.
    ///
    /// - Returns: FlatButton instance with pre-set design properties.
    class func cancelButton() -> FlatButton {
        let cancel = FlatButton(title: NSLocalizedString("CANCEL", comment: ""))
        cancel.titleColor = .white
        cancel.pulseColor = .white
        cancel.titleLabel?.font = RobotoFont.bold(with: 15)
        return cancel
    }
    
    /// Generates a done button used in ToolbarController as a right view.
    ///
    /// - Returns: IconButton instance with pre-set design properties.
    class func doneButton() -> IconButton {
        let done = IconButton(image: Icon.cm.check, tintColor: .white)
        done.pulseColor = .white
        return done
    }
}
