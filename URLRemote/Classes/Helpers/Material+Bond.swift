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

extension ReactiveExtensions where Base: RaisedButton {
    
    /// Binding with a button after EntryAction has been performed.
    var action: Bond<EntryActionStatus> {
        return bond { button, status in
            print(status)
            
            switch status {
            case .success:
                button.pulseColor = .green
            case .failure:
                button.pulseColor = .yellow
            case .error:
                button.pulseColor = .red
            }
            
            button.pulse()
            button.pulseColor = .white
        }
    }
}

extension ReactiveExtensions where Base: Toolbar {
    
    /// Binding for the toolbar's title.
    var title: Bond<String> {
        return bond { toolbar, title in
            toolbar.title = title
        }
    }
}

extension ReactiveExtensions where Base: TextField {
    
    /// Binding for the detail field of the TextField.
    var detail: Bond<String> {
        return bond { field, text in
            field.detail = text
        }
    }
}
