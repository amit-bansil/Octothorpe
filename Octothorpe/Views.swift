//
//  View.swift
//  
//
//  Created by Amit D. Bansil on 7/23/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

import UIKit

class BoardView: UIView {
    var model: Model?
    var board = [[PlayerView]]()
    var pointCount = 0
    
    override func layoutSubviews() {
        if let model = self.model {
            if(board.count == 0){
                for column in 0..<model.width {
                    board.append([PlayerView]())
                    for row in 0..<model.height {
                        let cell = PlayerView()
                        cell.backgroundColor = UIColor.clearColor()
                        cell.addGestureRecognizer(UITapGestureRecognizzle() {
                            let coords = Point(x:column, y:row)
                            if model.getPlayerAt(coords) == nil {
                                model.move(coords)
                                dropIn(cell, 0)
                                cell.player = model.getPlayerAt(coords)
                                cell.setNeedsDisplay()
                                self.bringSubviewToFront(cell)
                                let lines = model.hits
                                for line in lines[self.pointCount..<lines.count] {
                                    self.drawLine(line)
                                }
                                self.pointCount = lines.count
                            }
                        })
                        addSubview(cell)
                        board[column].append(cell)
                    }
                }
            }
            
            let bounds = self.bounds
            let w = bounds.width / CGFloat(model.width)
            let h = bounds.height / CGFloat(model.height)
            for column in 0..<model.width {
                for row in 0..<model.height {
                    board[column][row].frame = CGRect(
                        x:CGFloat(column) * w + bounds.minX,
                        y:CGFloat(row) * h + bounds.minY,
                        width:w,
                        height:h)
                }
            }

        }
    }
    func drawLine(line: Line) {
        if let model = self.model {
            let w = bounds.width / CGFloat(model.width)
            let h = bounds.height / CGFloat(model.height)
            let points = pointsFromLine(line)
            for i in 0..<points.count - 1 {
                let (x0, y0) = points[i].destructure()
                let (x1, y1) = points[i+1].destructure()
                let start = ((CGFloat(x0) + 0.5) * w, (CGFloat(y0) + 0.5) * h)
                let end = ((CGFloat(x1) + 0.5) * w, (CGFloat(y1) + 0.5) * h)
                drawPoint(line.player, start:start, end:end, delta:0.42, delay:Double(i) * 0.3)
                drawPoint(line.player, start:start, end:end, delta:0.58, delay:Double(i) * 0.3 + 0.2)
            }
        }
    }
    typealias CGPoint = (x: CGFloat, y: CGFloat)
    func drawPoint(player:Player, start:CGPoint, end:CGPoint, delta:CGFloat, delay: NSTimeInterval){
        let w = CGFloat(5.0), h = CGFloat(5.0)
        let p = (start.x + (end.x - start.x) * delta, start.y + (end.y - start.y) * delta)
        let v = DotView(frame:CGRect(x:p.0 - w / 2.0, y: p.1 - h / 2.0, width: w, height: h), player:player)
        addSubview(v)
        dropIn(v, delay)
    }
}

//draws a players symbol (x/o) or a dot if unassigned
class PlayerView: UIView {
    var player: Player?
    
    override func drawRect(rect: CGRect) {
        let pen = UIGraphicsGetCurrentContext()
        var bounds = self.bounds
        //fix for self.bounds occasionaly returning incorrect values
        if(self.bounds.width != frame.width) {
            NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("setNeedsDisplay"), userInfo: nil, repeats: false)
            return
        }
        colorForPlayer(player).set()
        switch player {
        case .Some(.X):
            CGContextSetLineWidth(pen, 10)
            CGContextSetLineCap(pen, kCGLineCapSquare)
            bounds = CGRectInset(bounds, 18, 18)
            CGContextMoveToPoint(pen, bounds.minX, bounds.minY)
            CGContextAddLineToPoint(pen, bounds.maxX, bounds.maxY)
            CGContextMoveToPoint(pen, bounds.minX, bounds.maxY)
            CGContextAddLineToPoint(pen, bounds.maxX, bounds.minY)
            CGContextStrokePath(pen)
        case .Some(.O):
            CGContextSetLineWidth(pen, 10)
            bounds = CGRectInset(bounds, 15, 15)
            CGContextAddArc(pen, bounds.midX, bounds.midY, bounds.width / 2.0, 0.0, CGFloat(M_PI) * 2.0, 1)
            CGContextStrokePath(pen)
        default:
            CGContextSetLineWidth(pen, 5)
            CGContextFillEllipseInRect(pen, CGRectInset(bounds, 28, 28))
        }
    }
}

//draws a left facing arrow head
class ArrowView: UIView {
    override func drawRect(rect: CGRect) {
        let bounds = self.bounds
        let pen = UIGraphicsGetCurrentContext()
        CGContextSetLineCap(pen, ARROW_LINE_CAP)
        ARROW_COLOR.set()
        CGContextMoveToPoint(pen, bounds.maxX,bounds.minY)
        CGContextAddLineToPoint(pen, bounds.maxX,bounds.maxY)
        CGContextAddLineToPoint(pen, bounds.minX,bounds.midY)
        CGContextAddLineToPoint(pen, bounds.maxX,bounds.minY)
        CGContextFillPath(pen)
    }
}

//represents a number as a tally of tick marks centered on the X Axis
class TallyView: UIView {
    var tally: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    var player: Player?
    
    override func drawRect(rect: CGRect)  {
        let pen = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(pen, 3)
        CGContextSetLineCap(pen, TALLY_LINE_CAP)
        colorForPlayer(player).set()
        
        let bounds = self.bounds
        let markGap = CGFloat(5)
        let slashHang = CGFloat(3)
        let groupGap = CGFloat(2)
        let groupCount = CGFloat(floor(CGFloat(tally) / 5.0))
        var totalWidth = (CGFloat(tally) - groupCount) * markGap
        totalWidth += (max(groupCount - 1, 0) * (groupGap + slashHang))
        
        var x0 = bounds.width / 2.0 - totalWidth / 2.0
        x0 += 1.5 //width of line
        var tallyDrawn = 0
        
        for _ in 0...Int(groupCount) {
            let tallyStart = x0
            for i in 0..<5 {
                if tallyDrawn == tally {
                    CGContextStrokePath(pen)
                    return
                }
                if i != 4 {
                    CGContextMoveToPoint(pen, x0, bounds.minY)
                    CGContextAddLineToPoint(pen, x0, bounds.maxY)
                    x0 += markGap
                } else {
                    CGContextMoveToPoint(pen, tallyStart - markGap, bounds.maxY - 5.0)
                    CGContextAddLineToPoint(pen, x0, bounds.minY + 5.0)
                }
                ++tallyDrawn
            }
            x0 += groupGap
            x0 += slashHang
        }
    }
}

//draws a dot colored by a player's color
class DotView: UIView{
    required init(coder aDecoder: NSCoder!) {
        fatalError("NSCoding not supported")
    }
    
    var player: Player
    init(frame: CGRect, player: Player) {
        self.player = player
        super.init(frame:frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        let pen = UIGraphicsGetCurrentContext()
        var bounds = self.bounds
        colorForPlayer(player).set()
        CGContextFillEllipseInRect(pen, bounds)
    }
}

