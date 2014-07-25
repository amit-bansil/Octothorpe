//
//  Model.swift
//  T4
//
//  Created by Amit D. Bansil on 7/20/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

public typealias T4Point = (x: Int, y: Int)
public enum T4Player {
    case X, O
}
public typealias T4Line = (player:T4Player, startingAt: T4Point, heading: T4Point)

public func==(lhs: T4Point, rhs:T4Point)-> Bool{
    return lhs.x == rhs.x && lhs.y == rhs.y
}
public func==(lhs: T4Line, rhs:T4Line)-> Bool{
    return lhs.player == rhs.player
        && lhs.heading == rhs.heading
        && lhs.startingAt == rhs.startingAt
}
public class T4Model: Observable {
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
    var coordinates: [T4Point] {
    get{
        var ret = [T4Point]()
        for x in 0..<width {
            for y in 0..<height {
                ret += (x,y)
            }
        }
        return ret
    }
    }
    public func getPlayerAt(point: T4Point)-> T4Player? {
        return board[point.x][point.y]
    }
    
    private var oldHits = [T4Line]()
    var hits: [T4Line] {
    get {
        var ret = [T4Line]()
        ret += getHitLines(.X)
        ret += getHitLines(.O)
        
        for oldLine in oldHits {
            ret = ret.filter({ !($0 == oldLine) })
        }
        
        oldHits += ret
        
        return oldHits
    }
    }
    
    func getHitLines(player: T4Player)-> [(T4Line)]{
        var ret = [(T4Line)]()
        for coordinate in coordinates {
            for direction in INCREASING_UNIT_VECTORS {
                let line = T4Line(player, coordinate, direction)
                if isWinningLine(line) {
                    ret += line
                }
            }
        }
        return ret
    }
    
    public func pointsFromLine(line: T4Line)-> [T4Point] {
        var ret = [T4Point]()
        for d in 0..<winLength {
            let x = line.startingAt.x + d * line.heading.x
            let y = line.startingAt.y + d * line.heading.y
            ret += (x,y)
        }
        return ret
    }

    func isWinningLine(line: T4Line)-> Bool {
        for p in pointsFromLine(line) {
            if self.board.qGet(p.x)?.qGet(p.y)? != line.player {
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
        dispatchEvent()
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
    ret = ret.filter { ($0.x == 1 || $0.y == 1) && ($0.x != 1 || $0.y != -1) }
    return ret
}
private let INCREASING_UNIT_VECTORS = getIncreasingUnitVectors()