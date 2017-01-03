//
//  ActionViewCell.swift
//  URLRemote
//
//  Created by Michal Švácha on 14/12/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import UIKit
import Material

///
class ActionViewCell: UICollectionViewCell {
    var button: RaisedButton?
    
    ///
    func setUpView() {
        if button == nil {
            button = RaisedButton(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            button?.backgroundColor = UIColor.gray
            button?.layer.cornerRadius = self.frame.width / 2.0
            self.addSubview(button!)
        }
    }
    
    ///
    ///
    /// - Parameter entry:
    func bind(with entry: Entry) {
        var color = UIColor.gray
        if let hex = entry.color, let hexEnum = ColorName(rawValue: hex) {
            color = UIColor(named: hexEnum)
        }
        button?.backgroundColor = color
        
        if let url = entry.url {
            _ = button?.bnd_tap.observe() { _ in self.bindSignal(url: url) }
        }
    }
    
    func bindSignal(url: String) {
        _ = self.button?.bndAction.bind(signal:
            EntryAction().signalForAction(url: url)
        )
    }
}
