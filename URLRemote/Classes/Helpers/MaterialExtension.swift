//
//  MaterialExtension.swift
//  URLRemote
//
//  Created by Michal Švácha on 29/05/2017.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import Material
import Motion

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
    
    /// Generates a FlatButton with given title.
    ///
    /// - Returns: FlatButton instance with pre-set design properties.
    private class func flatButton(title: String) -> FlatButton {
        let button = FlatButton(title: title)
        button.apply(Stylesheet.General.flatButton)
        return button
    }
    
    /// Generates a cancel button used in ToolbarController as a left view.
    ///
    /// - Returns: FlatButton instance with pre-set design properties.
    class func cancelButton() -> FlatButton {
        return flatButton(title: NSLocalizedString("CANCEL", comment: ""))
    }
    
    /// Generates a close button used in ToolbarController as a left view.
    ///
    /// - Returns: FlatButton instance with pre-set design properties.
    class func closeButton() -> FlatButton {
        return flatButton(title: NSLocalizedString("CLOSE", comment: ""))
    }
    
    /// Generates an icon button with supplied image.
    ///
    /// - Parameter image: Image to set as the icon on the button.
    /// - Returns: IconButton instance with pre-set design properties.
    class func genericIconButton(image: UIImage?) -> IconButton {
        let button = IconButton(image: image, tintColor: .white)
        button.pulseColor = .white
        return button
    }
}
