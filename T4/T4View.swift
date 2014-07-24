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
                label.text = "aba"
                label.fontSize = 65;
                label.position = makePoint(Float(x + 0.5) / Float(model.width), Float(y + 0.5) / Float(model.height))
                squares[x] += label
                node.addChild(label)
            }
        }
        
        node.addChild(drawGrid())
        
        model.addListener(self.update)
    }
    func drawGrid()->SKNode {
        let gridNode = SKShapeNode();
        let gridPath = UIBezierPath();
        for column in 1..<model.width {
            let x = Float(column) /  Float(model.width)
            drawLine(gridPath, x, x, 0, 1)
        }
        for row in 1..<model.height {
            let y = Float(row) /  Float(model.height)
            drawLine(gridPath, 0, 1, y, y)
        }
        
        gridNode.path = gridPath.CGPath;
        gridNode.lineWidth = 10.0;
        gridNode.strokeColor = UIColor.whiteColor();
        gridNode.antialiased = false;
        gridNode.position = CGPoint(x:0.5, y:0.5)
        
        return gridNode
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
            squares[coordinate.x][coordinate.y].text = text
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
            return ""
        }
    }
}