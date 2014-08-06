//
//
//  Created by Amit D. Bansil on 7/31/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

import UIKit

class LeftArrow: UIView {
    override func drawRect(rect: CGRect) {
        let bounds = self.bounds
        let pen = UIGraphicsGetCurrentContext()
        CGContextSetLineCap(pen, kCGLineCapSquare)
        UIColor.fromHex(0xd0d0d0).set()
        CGContextMoveToPoint(pen, bounds.maxX,bounds.minY)
        CGContextAddLineToPoint(pen, bounds.maxX,bounds.maxY)
        CGContextAddLineToPoint(pen, bounds.minX,bounds.midY)
        CGContextAddLineToPoint(pen, bounds.maxX,bounds.minY)
        CGContextFillPath(pen)
    }
}
