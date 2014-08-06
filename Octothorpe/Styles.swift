//
//  Styles.swift
//  Octothorpe
//
//  Created by Amit D. Bansil on 8/6/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

import UIKit

let ARROW_COLOR = UIColor.fromHex(0xd0d0d0)
let ARROW_LINE_CAP = kCGLineCapSquare

let TALLY_LINE_CAP = kCGLineCapSquare

func colorForPlayer(player: Player?)-> UIColor {
    switch player {
    case .Some(.X):
        return UIColor.fromHex(0xE35050)
    case .Some(.O):
        return UIColor.fromHex(0x50E3C2)
    default:
        return UIColor.whiteColor()
    }
}


func styleDirections(directions: UILabel) {
    let heading = "Playing Octothorpe"
    let body = ": Grab a friend and take turns tapping the dots above. Whoever has the most lines of three when the board is full wins."
    let str = NSMutableAttributedString(string:heading + body)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 2.0
    str.setAttributes([NSFontAttributeName: UIFont(name:"AvenirNext-DemiBold", size:15), NSParagraphStyleAttributeName:paragraphStyle], range:NSRange(location:0, length:countElements(heading)))
    str.setAttributes([NSFontAttributeName:UIFont(name:"Avenir Next", size:15), NSParagraphStyleAttributeName:paragraphStyle], range:NSRange(location:countElements(heading), length:countElements(body)))
    directions.attributedText = str
}

func rotate180(view: UIView) {
    UIView.animateWithDuration(0.3,
        delay:0.0,
        options:.CurveEaseOut,
        animations:{
            view.transform = CGAffineTransformRotate(view.transform, CGFloat(M_PI));
        },
        completion:{
            (t: Bool) in
        }
    )
}

func dropIn(view: UIView, delay: NSTimeInterval) {
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.5, 2.5);
    view.hidden = true
    UIView.animateWithDuration(delay,
        delay:0.0,
        options:.CurveEaseOut,
        animations:{},
        completion:{
            (t: Bool) in
            view.hidden = false
            UIView.animateWithDuration(0.15,
                delay:0.0,
                options:.CurveEaseOut,
                animations:{
                    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                },
                completion:{
                    (t: Bool) in
                }
            )
        }
    )
}
