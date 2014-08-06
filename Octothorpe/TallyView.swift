//
//  TallyView.swift
//
//  Created by Amit D. Bansil on 7/30/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

import UIKit

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
