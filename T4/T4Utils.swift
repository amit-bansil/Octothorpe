//
//  Utils.swift
//
//  Created by Amit D. Bansil on 7/23/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

import SpriteKit

//lookup possibly out of bounds element of array
public extension Array {
    public func qGet(index: Int)-> T?{
        if index < 0 || index >= count {
            return nil
        }else{
            return self[index]
        }
    }
    mutating func remove <U: Equatable> (element: U) {
        let anotherSelf = self
        
        removeAll(keepCapacity: true)
        
        anotherSelf.each {
            (index: Int, current: Element) in
            if current as U != element {
                self.append(current)
            }
        }
    }
    func each (call: (Element) -> ()) {
        
        for item in self {
            call(item)
        }
        
    }
    func each (call: (Int, Element) -> ()) {
        
        for (index, item) in enumerate(self) {
            call(index, item)
        }
        
    }
}

public class Observable {
    public typealias Listener = ()->()
    //Memory leak??
    private var listeners = [Listener]()
    
    public func addListener(listener: Listener){
        listeners += listener
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

extension CGPoint {
    func moveToward(target: CGPoint, amount: Double)-> CGPoint {
        let tx: Double = Double(target.x), ty: Double = Double(target.y), x: Double = Double(self.x), y: Double = Double(self.y)
        return CGPoint(x: CGFloat(x + (tx - x) * amount),
            y: CGFloat(y + (ty - y) * amount))
    }
}