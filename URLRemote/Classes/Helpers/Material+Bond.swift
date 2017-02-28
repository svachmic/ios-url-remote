//
//  RaisedButton+Bond.swift
//  URLRemote
//
//  Created by Michal Švácha on 16/12/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import Foundation
import Material
import Bond
import ReactiveKit

/// ReactiveKit/Bond bindings for Material components.

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

extension ReactiveExtensions where Base: FABMenu {
    
    /// Binding for menu toggle open/collapse on button tap.
    var bndToggle: Bond<Void> {
        return bond { menu, _ in
            menu.toggle()
        }
    }
}

extension ReactiveExtensions where Base: RaisedButton {
    
    /// Binding with a button after EntryAction has been performed.
    var bndAction: Bond<EntryActionStatus> {
        return bond { button, status in
            print(status)
            
            switch status {
            case .success:
                button.pulseColor = .green
                break
            case .failure:
                button.pulseColor = .yellow
                break
            case .error:
                button.pulseColor = .red
                break
            }
            
            button.pulse()
            button.pulseColor = .white
        }
    }
}

extension ReactiveExtensions where Base: Toolbar {
    
    /// Binding for the toolbar's title.
    var bndTitle: Bond<String> {
        return bond { toolbar, title in
            toolbar.title = title
        }
    }
}

extension ReactiveExtensions where Base: TextField {
    
    /// Binding for the detail field of the TextField.
    var bndDetail: Bond<String> {
        return bond { field, text in
            field.detail = text
        }
    }
}
