//
//  T4DotView.swift
//  T4
//
//  Created by Amit D. Bansil on 7/29/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

import UIKit

class T4DotView: UIView{
    var player: T4Player
    init(frame: CGRect, player: T4Player) {
        self.player = player
        super.init(frame:frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        let pen = UIGraphicsGetCurrentContext()
        var bounds = self.bounds
        switch player {
        case .X:
            UIColor.fromHex(0xE35050).set()
        case .O:
            UIColor.fromHex(0x50E3C2).set()
        }
        CGContextFillEllipseInRect(pen, CGRectInset(bounds, 0, 0))
    }
}
