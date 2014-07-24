//
//  T4App.swift
//  T4
//
//  Created by Amit D. Bansil on 7/23/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

import SpriteKit

class T4App {
    private let model = T4Model(width: 4, height: 5, winLength: 3)
    private var touchController: T4TouchController?
    private var view: T4View?
    
    init(){}
    
    func onTouch(location: CGPoint) {
        touchController!.onTouch(location)
    }
    func setup(frame: CGRect)->SKNode {
        touchController = T4TouchController(model:model, frame:frame)
        view = T4View(model:model, frame:frame)
        return view!.node
    }
}