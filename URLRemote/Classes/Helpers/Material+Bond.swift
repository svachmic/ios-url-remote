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

extension Menu: MenuDelegate {
    
    /// Toggles the menu open/close.
    func toggle() {
        var angle: CGFloat = 0.0
        
        if self.isOpened {
            self.close()
            for v in self.views {
                (v as? MenuItem)?.hideTitleLabel()
            }
        } else {
            angle = 45.0
            self.open()
            for v in self.views {
                (v as? MenuItem)?.showTitleLabel()
            }
            
        }
        
        self.views.first?.animate(animation: Motion.animate(
            group: [Motion.rotate(angle: angle, duration: 0.1)]
        ))
    }
    
    /// Binding for menu toggle open/collapse on button tap.
    var bndToggle: Bond<Menu, Void> {
        return Bond(target: self) { _, _ in
            self.toggle()
        }
    }
    
    /// MARK: - Menu delegate method
    
    ///
    public func menu(menu: Menu, tappedAt point: CGPoint, isOutside: Bool) {
        if isOutside {
            menu.toggle()
        }
    }
}

extension RaisedButton {
    
    /// Binding with a button after EntryAction has been performed.
    var bndAction: Bond<RaisedButton, EntryActionStatus> {
        return Bond(target: self) { button, status in
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

extension Toolbar {
    
    /// Binding for the toolbar's title.
    var bndTitle: Bond<Toolbar, String> {
        return Bond(target: self) { toolbar, title in
            toolbar.title = title
        }
    }
}

extension TextField {
    
    /// Binding for the detail field of the TextField.
    var bndDetail: Bond<TextField, String> {
        return Bond(target: self) { field, text in
            field.detail = text
        }
    }
}
