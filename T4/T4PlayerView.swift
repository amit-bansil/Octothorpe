//
//  T4PlayerView.swift
//  T4
//
//  Created by Amit D. Bansil on 7/29/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

import UIKit

class T4PlayerView: UIView {
    var player: T4Player?
    
    override func drawRect(rect: CGRect) {
        let pen = UIGraphicsGetCurrentContext()
        var bounds = self.bounds
        //fix for self.bounds occasionaly returning incorrect values
        if(self.bounds.width != frame.width) {
            NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("setNeedsDisplay"), userInfo: nil, repeats: false)
            return
        }
        switch player {
        case .Some(.X):
            CGContextSetLineWidth(pen, 10)
            CGContextSetLineCap(pen, kCGLineCapSquare)
            bounds = CGRectInset(bounds, 18, 18)
            UIColor.fromHex(0xE35050).set()
            CGContextMoveToPoint(pen, bounds.minX, bounds.minY)
            CGContextAddLineToPoint(pen, bounds.maxX, bounds.maxY)
            CGContextMoveToPoint(pen, bounds.minX, bounds.maxY)
            CGContextAddLineToPoint(pen, bounds.maxX, bounds.minY)
            CGContextStrokePath(pen)
        case .Some(.O):
            CGContextSetLineWidth(pen, 10)
            bounds = CGRectInset(bounds, 15, 15)
            UIColor.fromHex(0x50E3C2).set()
            CGContextAddArc(pen, bounds.midX, bounds.midY, bounds.width / 2.0, 0.0, CGFloat(M_PI) * 2.0, 1)
            CGContextStrokePath(pen)
        default:
            CGContextSetLineWidth(pen, 5)
            UIColor.fromHex(0xDDDDDD).set()
            CGContextFillEllipseInRect(pen, CGRectInset(bounds, 28, 28))
        }
    }
}