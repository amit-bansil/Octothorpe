//
//  DotView.swift
//
//  Created by Amit D. Bansil on 7/29/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

import UIKit

class DotView: UIView{
    var player: Player
    init(frame: CGRect, player: Player) {
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
