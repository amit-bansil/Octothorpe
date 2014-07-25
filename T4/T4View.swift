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
    var hitCount = 0
    
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
                label.position = pointForSquare((x,y))
                
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
    func pointForSquare(point: T4Point)->CGPoint {
        return makePoint(Float(point.x + 0.5) / Float(model.width),
            Float(point.y + 0.5) / Float(model.height))
    }
    func update() {
        let hits = model.hits
        
        for hit in hits[hitCount..<hits.count] {
            let points = model.pointsFromLine(hit)
            var delay = 0.0
            for i in 0..<model.winLength - 1 {
                addHitHint(points[i], nextPoint:points[i + 1], player:hit.player, amount:0.3, delay: delay)
                addHitHint(points[i], nextPoint:points[i + 1], player:hit.player, amount:0.4, delay: delay)
                addHitHint(points[i], nextPoint:points[i + 1], player:hit.player, amount:0.6, delay: delay)
                addHitHint(points[i], nextPoint:points[i + 1], player:hit.player, amount:0.7, delay: delay)
                delay += 0.4
            }
        }
        hitCount = hits.count
        for coordinate in model.coordinates {
            let owner = model.getPlayerAt(coordinate)
            let text = getPlayerText(owner)
            let label = squares[coordinate.x][coordinate.y]
            if label.text != text {
                label.text = text
                label.fontColor = getPlayerColor(owner!)
                dropIn(label, delay:0)
            }
        }
    }
    func addHitHint(prevPoint: T4Point, nextPoint: T4Point, player: T4Player,
        amount: Double, delay: Double){
            
        let label = SKLabelNode(fontNamed:"Chalkduster")
        label.text = "·"
        label.fontColor = getPlayerColor(player)
        label.fontSize = 18
        label.verticalAlignmentMode = .Center
        label.horizontalAlignmentMode = .Center
        
        let prevCGPoint = pointForSquare(prevPoint)
        let nextCGPoint = pointForSquare(nextPoint)
        
        label.position = prevCGPoint.moveToward(nextCGPoint, amount:amount)
        dropIn(label, delay:amount / 2 + delay)
        node.addChild(label)
    }
    func dropIn(node: SKNode, delay: Double) {
        node.alpha = 0
        node.xScale = CGFloat(10.0)
        node.yScale = CGFloat(10.0)
        let fadeAction = SKAction.fadeInWithDuration(0.2)
        let scaleAction = SKAction.scaleTo(1, duration:0.2)
        fadeAction.timingMode = .EaseOut
        scaleAction.timingMode = .EaseOut
        let dropAction = SKAction.runBlock {
            node.runAction(fadeAction)
            node.runAction(scaleAction)
        }
        let delayAction = SKAction.waitForDuration(delay)
        
        let sequenceAction = SKAction.sequence([delayAction, dropAction])
        node.runAction(sequenceAction)
    }
    
    func getPlayerColor(player: T4Player)-> UIColor {
        switch player {
        case .X:
            return UIColor.fromHex(0xCC2A41)
        case .O:
            return UIColor.fromHex(0x759A8A)
        }
    
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