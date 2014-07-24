//
//  GameScene.swift
//  test
//
//  Created by Amit D. Bansil on 7/23/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

import SpriteKit

class T4Scene: SKScene {
    let app = T4App()
    
    override func didMoveToView(view: SKView) {
        self.addChild(app.setup(view.frame))
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            app.onTouch(location)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
    }
}
