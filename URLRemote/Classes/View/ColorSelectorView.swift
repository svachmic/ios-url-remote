//
//  ColorSelectorView.swift
//  URLRemote
//
//  Created by Michal Švácha on 08/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import UIKit
import Material
import ReactiveKit

/// View with round color buttons that emits signals after a button has been pressed.
class ColorSelectorView: UIView {
    /// Signal emitter - emits signal upon button click (the color of the button).
    let signal = PublishSubject<ColorName, NoError>()

    /// Required initializer for the storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Sets up all buttons and hooks them up to the signal emitter.
    ///
    /// - Parameter colors: Array with ColorName enum values to fill buttons with. This is the enum that later on gets emitted through the signal.
    func setupViews(with colors: [ColorName]) {
        let margin: CGFloat = 10.0
        let size = self.frame.height
        
        if (CGFloat(colors.count) * (margin + size)) > self.frame.width {
            fatalError("This number of colors won't fit.")
        }
        
        for index in 0..<colors.count {
            let x = CGFloat(index) * (size + margin)
            let button = FlatButton(frame: CGRect(x: x, y: 0, width: size, height: size))
            button.pulseColor = .white
            button.backgroundColor = UIColor(named: colors[index])
            button.layer.cornerRadius = size / 2.0
            _ = button.bnd_tap.observeNext {
                self.signal.next(colors[index])
            }
            self.addSubview(button)
        }
    }
}
