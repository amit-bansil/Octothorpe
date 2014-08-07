//
//  View.swift
//  
//
//  Created by Amit D. Bansil on 7/23/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

import UIKit

class BoardView: UIView {
    var model: Model? {
        didSet{
            //Memory leak!
            model?.addListener(modelChanged)
        }
    }
    var board = [Point:PlayerView]()
    var pointCount = 0
    
    override func layoutSubviews() {
        if self.model != nil {
            if(board.count == 0){
                setupBoard()
            }
            
            layoutBoard()
        }
    }
    
    func setupBoard() {
        let model = self.model!
        for point in model.coordinates {
            let cell = PlayerView()
            cell.backgroundColor = UIColor.clearColor()
            cell.addGestureRecognizer(UITapGestureRecognizzle() {
                self.cellTapped(point)
            })
            addSubview(cell)
            board[point] = cell
        }
    }
    
    func layoutBoard() {
        let model = self.model!
        let bounds = self.bounds
        let w = bounds.width / CGFloat(model.width)
        let h = bounds.height / CGFloat(model.height)
        for point in model.coordinates {
            board[point]!.frame = CGRect(
                x:CGFloat(point.x) * w + bounds.minX,
                y:CGFloat(point.y) * h + bounds.minY,
                width:w,
                height:h)
        }
    }
    
    func cellTapped(point: Point) {
        let model = self.model!
        if model.getPlayerAt(point) == nil {
            model.move(point)
        } else {
            //TODO: bounce cell
        }
    }
    
    func modelChanged() {
        let model = self.model!
        for point in model.coordinates {
            if model.getPlayerAt(point) != board[point]!.player {
                let cell = board[point]!
                dropIn(cell, 0)
                cell.player = model.getPlayerAt(point)
                cell.setNeedsDisplay()
                self.bringSubviewToFront(cell)
            }
        }
        
        let lines = model.hits
        for line in lines[self.pointCount..<lines.count] {
            self.drawLine(line)
        }
        self.pointCount = lines.count
    }
    
    func drawLine(line: Line) {
        if let model = self.model {
            let w = bounds.width / CGFloat(model.width)
            let h = bounds.height / CGFloat(model.height)
            let points = pointsFromLine(line)
            for i in 0..<points.count - 1 {
                let (x0, y0) = points[i].destructure()
                let (x1, y1) = points[i+1].destructure()
                let start = CGPoint(x:(CGFloat(x0) + 0.5) * w, y:(CGFloat(y0) + 0.5) * h)
                let end = CGPoint(x:(CGFloat(x1) + 0.5) * w, y:(CGFloat(y1) + 0.5) * h)
                drawPoint(line.player, start:start, end:end,
                    delta:0.42, delay:Double(i) * 0.3)
                drawPoint(line.player, start:start, end:end,
                    delta:0.58, delay:Double(i) * 0.3 + 0.2)
            }
        }
    }
    
    func drawPoint(player: Player, start: CGPoint, end: CGPoint,
                   delta: Double, delay: NSTimeInterval){
        let size   = CGSize(width:OpenSquareDotSize, height:OpenSquareDotSize)
        var origin = start.moveToward(end, amount: delta)
        origin = origin - 0.5 * CGPoint(x: OpenSquareDotSize, y: OpenSquareDotSize)
        let v = DotView(frame:CGRect(origin: origin, size: size), player:player)
        addSubview(v)
        dropIn(v, delay)
    }
}

//draws a players symbol (x/o) or a dot if unassigned
class PlayerView: UIView {
    var player: Player?
    
    override func drawRect(rect: CGRect) {
        //fix for self.bounds occasionaly returning incorrect values
        if(self.bounds.width != frame.width) {
            NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("setNeedsDisplay"), userInfo: nil, repeats: false)
            return
        }
        colorForPlayer(player).set()
        switch player {
        case .Some(.X):
            drawX()
        case .Some(.O):
            drawO()
        default:
            drawDot()
        }
    }
    func drawX() {
        let pen = UIGraphicsGetCurrentContext()
        var bounds = self.bounds
        
        CGContextSetLineWidth(pen, XStrokeWidth)
        CGContextSetLineCap(pen, kCGLineCapSquare)
        bounds = CGRectInset(bounds, XInset, XInset)
        CGContextMoveToPoint(pen, bounds.minX, bounds.minY)
        CGContextAddLineToPoint(pen, bounds.maxX, bounds.maxY)
        CGContextMoveToPoint(pen, bounds.minX, bounds.maxY)
        CGContextAddLineToPoint(pen, bounds.maxX, bounds.minY)
        CGContextStrokePath(pen)
    }
    func drawO() {
        let pen = UIGraphicsGetCurrentContext()
        var bounds = self.bounds
        
        CGContextSetLineWidth(pen, OStrokeWidth)
        bounds = CGRectInset(bounds, OInset, OInset)
        CGContextAddArc(pen, bounds.midX, bounds.midY, bounds.width / 2.0, 0.0, CGFloat(M_PI) * 2.0, 1)
        CGContextStrokePath(pen)
    }
    func drawDot() {
        let pen = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(pen, HitDotStrokeWidth)
        CGContextFillEllipseInRect(pen, CGRectInset(self.bounds, HitDotInset, HitDotInset))
    }
}

//draws a left facing arrow head
class ArrowView: UIView {
    override func drawRect(rect: CGRect) {
        let bounds = self.bounds
        let pen = UIGraphicsGetCurrentContext()
        CGContextSetLineCap(pen, ArrowLineCap)
        ArrowColor.set()
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
        CGContextSetLineCap(pen, TallyLineCap)
        colorForPlayer(player).set()
        
        let bounds = self.bounds
        let groupCount = CGFloat(floor(CGFloat(tally) / 5.0))
        
        var totalWidth = (CGFloat(tally) - groupCount) * TallyMarkGap
        totalWidth += (max(groupCount - 1, 0) * (TallyGroupGap + TallySlashHang))
        totalWidth -= 3.0 //width of line
        
        var x0 = bounds.width / 2.0 - totalWidth / 2.0
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
                    x0 += TallyMarkGap
                } else {
                    CGContextMoveToPoint(pen, tallyStart - TallyMarkGap,
                        bounds.maxY - TallySlashYOffset)
                    CGContextAddLineToPoint(pen, x0,
                        bounds.minY + TallySlashYOffset)
                }
                ++tallyDrawn
            }
            x0 += TallyGroupGap
            x0 += TallySlashHang
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

