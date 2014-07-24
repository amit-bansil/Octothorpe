//
//  Utils.swift
//  T4
//
//  Created by Amit D. Bansil on 7/23/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

//lookup possibly out of bounds element of array
public extension Array {
    public func qGet(index: Int)-> T?{
        if index < 0 || index >= count {
            return nil
        }else{
            return self[index]
        }
    }
}

class Observable {
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