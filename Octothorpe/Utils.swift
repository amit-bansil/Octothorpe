//
//  Utils.swift
//
//  Created by Amit D. Bansil on 7/23/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

import SpriteKit

public class Observable {
    public typealias Listener = ()->()
    //Memory leak??
    private var listeners = [Listener]()
    
    public func addListener(listener: Listener){
        listeners.append(listener)
    }
    func dispatchEvent(){
        for listener in listeners {
            listener()
        }
    }
}

extension UIColor {
    class func fromHex(hexValue: UInt32)-> UIColor{
        let r = Float((hexValue & 0xFF0000) >> 16) / (255.0)
        let g = Float((hexValue & 0xFF00) >> 8) / (255.0)
        let b = Float(hexValue & 0xFF) / (255.0)
        return UIColor(
            red:CGFloat(r),
            green:CGFloat(g),
            blue:CGFloat(b),
            alpha:1.0)
    }
}

//allows use of closure as TapGestureRecognizer
class UITapGestureRecognizzle : UITapGestureRecognizer {
    var target : () -> ()
    
    init(target: () -> ()) {
        self.target = target
        
        super.init(target: self, action: "invokeTarget:")
    }
    
    func invokeTarget(nizer: UITapGestureRecognizer!) {
        target()
    }
}

extension CGPoint {
    func moveToward(target: CGPoint, amount: Double)-> CGPoint {
        return self + CGFloat(amount) * (target - self)
    }
}

func +(lhs: CGPoint, rhs: CGPoint)-> CGPoint {
    return CGPoint(x:lhs.x + rhs.x, y:lhs.y + rhs.y)
}

func *(lhs: CGFloat, rhs: CGPoint)-> CGPoint {
    return CGPoint(x:lhs * rhs.x, y:lhs * rhs.y)
}

func -(lhs: CGPoint, rhs: CGPoint)-> CGPoint {
    return lhs + -1 * rhs
}