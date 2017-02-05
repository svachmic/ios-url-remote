//
//  ActionViewCell.swift
//  URLRemote
//
//  Created by Michal Švácha on 14/12/16.
//  Copyright © 2016 Svacha, Michal. All rights reserved.
//

import UIKit
import Material

/// View for a single action represented by a collection view cell. Drawn as a round button with an icon representing the activity (picked by the user).
class ActionViewCell: UICollectionViewCell {
    var button: RaisedButton?
    
    /// Sets up the view by adding the button if it's not presented already.
    func setUpView() {
        if button == nil {
            button = RaisedButton(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            button?.backgroundColor = UIColor.gray
            button?.layer.cornerRadius = self.frame.width / 2.0
            self.addSubview(button!)
        }
    }
    
    /// Binds the button to the specific action.
    /// - Discussion: This approach works but could be improved.
    /// - Reason: Every time the button is tapped a new signal object is created.
    ///
    /// - Parameter entry: Model object that represents the action.
    func bind(with entry: Entry) {
        var color = UIColor.gray
        if let hex = entry.color {
            color = UIColor(named: hex)
        }
        button?.backgroundColor = color
        
        if let imageName = entry.icon, let image = UIImage(named: imageName) {
            button?.image = image.withRenderingMode(.alwaysTemplate)
            button?.imageView?.tintColor = .white
        }
        
        button?.pulseColor = .white
        
        if let url = entry.url {
            let action = EntryAction()
            
            _ = button?.bnd_tap.observe { _ in
                _ = self.button?.bndAction.bind(signal:
                    action.signalForAction(
                        url: url,
                        validator: ValidatorFactory.validator(for: entry),
                        requiresAuthentication: entry.requiresAuthentication,
                        user: entry.user,
                        password: entry.password)
                )
            }
        }
    }
}
