//
//  Utils.swift
//  T4
//
//  Created by Amit D. Bansil on 7/23/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

import Foundation

//lookup possibly out of bounds element of array
public extension Array {
    func qGet(index: Int)-> T?{
        if index < 0 || index >= count {
            return nil
        }else{
            return self[index]
        }
    }
}