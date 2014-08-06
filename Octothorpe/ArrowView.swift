//
//
//  Created by Amit D. Bansil on 7/31/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

import UIKit

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
