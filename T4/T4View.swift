//
//  T4View.swift
//  T4
//
//  Created by Amit D. Bansil on 7/23/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

import SpriteKit

class T4View {
    let model: T4Model
    public let node = SKNode()
    var squares = [[SKLabelNode]]()
    let frame: CGRect
    
    init(model: T4Model, frame: CGRect) {
        self.model = model
        self.frame = frame
        
        for x in 0..<model.width {
            squares += [SKLabelNode]()
            for y in 0..<model.height {
                let label = SKLabelNode(fontNamed:"Chalkduster")
                label.text = "·"
                label.fontColor = UIColor.fromHex(0x524549)
                label.fontSize = 36
                label.verticalAlignmentMode = .Center
                label.horizontalAlignmentMode = .Center
                label.position = makePoint(Float(x + 0.5) / Float(model.width), Float(y + 0.5) / Float(model.height))
                
                squares[x] += label
                node.addChild(label)
            }
        }
        
        model.addListener(self.update)
    }
    func drawLine(path: UIBezierPath, _ x0:Float, _ x1:Float, _ y0:Float, _ y1:Float){
        path.moveToPoint(makePoint(x0, y0))
        path.addLineToPoint(makePoint(x1, y1))
    }
    func makePoint(x: Float, _ y: Float)->CGPoint {
        return CGPointMake(CGFloat(x) * frame.width + frame.minX,
            CGFloat(y) * frame.height + frame.minY)
    }
    func update() {
        for coordinate in model.coordinates {
            let text = getPlayerText(model.getPlayerAt(coordinate))
            let label = squares[coordinate.x][coordinate.y]
            if label.text != text {
                if text == "X" {
                    label.fontColor = UIColor.fromHex(0xCC2A41)
                } else {
                    label.fontColor = UIColor.fromHex(0x759A8A)
                }
                label.text = text
                label.alpha = 0
                label.xScale = CGFloat(10.0)
                label.yScale = CGFloat(10.0)
                let fadeAction = SKAction.fadeInWithDuration(0.2)
                let scaleAction = SKAction.scaleTo(1, duration:0.2)
                fadeAction.timingMode = .EaseOut
                scaleAction.timingMode = .EaseOut
                label.runAction(fadeAction)
                label.runAction(scaleAction)
            }
        }
    }
    func aba(){
        
    }
    func getPlayerText(player: T4Player?)-> String {
        if let definitePlayer = player {
            switch definitePlayer {
            case .X:
                return "X"
            case .O:
                return "O"
            }
        }else{
            return "·"
        }
    }
}