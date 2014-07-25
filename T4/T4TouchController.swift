//
//  T4TouchController.swift
//  T4
//
//  Created by Amit D. Bansil on 7/23/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

import SpriteKit

class T4TouchController {
    let model: T4Model
    let frame: CGRect
    init(model: T4Model, frame: CGRect) {
        self.model = model
        self.frame = frame
    }
    func onTouch(location: CGPoint) {
        let px = (location.x - frame.minX) / frame.width
        let py = (location.y - frame.minY) / frame.height
        let x = Int(floor(Float(px) * Float(model.width)))
        let y = Int(floor(Float(py) * Float(model.height)))
        if x >= 0 && x < model.width && y >= 0 && y < model.height {
            if model.getPlayerAt((x,y)) == nil {
                model.move((x,y))
            }
        }
    }
}