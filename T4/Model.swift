//
//  Model.swift
//  T4
//
//  Created by Amit D. Bansil on 7/20/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

import Foundation

public typealias T4Point = (x: Int, y: Int)
public enum T4Player {
    case X, O
}

class T4Game {
    private var board:[[T4Player?]] //x, y
    
    private(set) var currentPlayer: T4Player
    public var mousedSquare: T4Point? {
    willSet {
        if let definiteValue = newValue {
            assert(board[definiteValue.x][definiteValue.y] == nil)
        }
    }
    }
    let winLength: Int
    
    init(width: Int, height: Int, winLength: Int) {
        self.winLength = winLength
        
        var board = [[T4Player?]]()
        for x in 0..<width {
            board += [T4Player?](count:height, repeatedValue:nil)
        }
        self.board = board
        
        currentPlayer = T4Player.X
    }
    var width: Int {
    get {
        return board.count
    }
    }
    var height: Int {
    get{
       return board[0].count
    }
    }
    public func getPlayerAt(point: T4Point)-> T4Player? {
        return board[point.x][point.y]
    }
    
    var winner: T4Player? {
    get {
        if isWinner(.X) {
            return T4Player.X
        }
        if isWinner(.O) {
            return T4Player.O
        }
        return nil
    }
    }
    
    func isWinner(player: T4Player)-> Bool{
        for (x, column) in enumerate(board) {
            for (y, square) in enumerate(column) {
                for direction in INCREASING_UNIT_VECTORS {
                    if isWinningLine(forPlayer:player, startingAt:(x, y), heading:direction) {
                        return true
                    }
                }
            }
        }
        return false
    }
    func isWinningLine(forPlayer player: T4Player, startingAt start: T4Point, heading: T4Point)-> Bool {
        for d in 0..<winLength {
            let x = start.x + d * heading.x
            let y = start.y + d * heading.y
            if self.board.qGet(x)?.qGet(y)? != player {
                return false
            }
        }
        return true
    }
    
    func move(square: T4Point) {
        assert(getPlayerAt(square) == nil)
        board[square.x][square.y] = currentPlayer
        switch currentPlayer {
        case .X:
            currentPlayer = .O
        case .O:
            currentPlayer = .X
        }
    }
}

//unit vectors that are all strictly increasing in at least 1 dimension
private func getIncreasingUnitVectors()->[T4Point] {
    var ret = [T4Point]()
    for x in -1...1 {
        for y in -1...1{
            ret += (x, y)
        }
    }
    ret.filter { $0.x == 1 || $0.y == 1 }
    return ret
}
private let INCREASING_UNIT_VECTORS = getIncreasingUnitVectors()