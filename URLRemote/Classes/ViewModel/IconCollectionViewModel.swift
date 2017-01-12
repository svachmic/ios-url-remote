//
//  IconCollectionViewModel.swift
//  URLRemote
//
//  Created by Michal Švácha on 10/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation
import Bond


///
class IconCollectionViewModel {
    ///
    
    let general = Observable2DArraySection<String, String>(
        metadata: NSLocalizedString("GENERAL", comment: ""),
        items: ["house_1", "house_2", "lock_on", "lock_off", "plus", "minus", "on", "off"]
    )
    
    let player = Observable2DArraySection<String, String>(
        metadata: NSLocalizedString("PLAYER", comment: ""),
        items: ["play", "pause", "stop", "rew", "fwd", "previous", "next"]
    )
    
    let lights = Observable2DArraySection<String, String>(
        metadata: NSLocalizedString("LIGHTS", comment: ""),
        items: ["lightbulb_on", "lightbulb_off", "day", "night"]
    )
    
    let arrows = Observable2DArraySection<String, String>(
        metadata: NSLocalizedString("ARROWS", comment: ""),
        items: ["up", "down", "left", "right", "double_up", "double_down", "double_left", "double_right"]
    )
    
    let contents = MutableObservable2DArray<String, String>([])
    
    var initialSelection = Observable<IndexPath?>(nil)
    var userSelection = Observable<IndexPath?>(nil)
    
    init() {
        self.contents.appendSection(general)
        self.contents.appendSection(player)
        self.contents.appendSection(lights)
        self.contents.appendSection(arrows)
    }
}
