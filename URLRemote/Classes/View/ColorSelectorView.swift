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

///
class ColorSelectorView: UIView {
    let colors = PublishSubject<ColorName, NoError>()

    ///
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    ///
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
                self.colors.next(colors[index])
            }
            self.addSubview(button)
        }
    }
}
