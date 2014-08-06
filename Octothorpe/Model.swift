//
//  Model.swift
//
//  Created by Amit D. Bansil on 7/20/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

//describes buisness logic of game in isolation from any rendering/interactivity
public class Model: Observable { //OOP w/o multiple inheritance. Yay!
    private var board = [Point:Player]()
    //player whose move it is next
    private(set) var currentPlayer: Player
    let winLength: Int
    let width: Int, height: Int
    
    init(width: Int, height: Int, winLength: Int) {
        self.winLength = winLength
        self.width = width
        self.height = height
        currentPlayer = .X
    }
    
    // return all coordinates on board
    var coordinates: [Point] {
    get{
        return generatePoints(0..<width, 0..<height)
    }
    }
    
    //return player (if any) who owns a given square
    func getPlayerAt(point: Point)-> Player? {
        return board[point]
    }
    
    private var oldHits = [Line]()
    //return all lines that count as points
    //any new hits are always appended to the array so the view
    //can detect changes
    var hits: [Line] {
    get {
        var ret = [Line]()
        ret += getHitLines(.X)
        ret += getHitLines(.O)
        
        for oldLine in oldHits {
            ret = ret.filter(){ !($0 == oldLine) }
        }
        
        oldHits += ret
        
        return oldHits
    }
    }
    
    //return hits for a specific player
    func getHitLines(player: Player)-> [(Line)]{
        var ret = [(Line)]()
        for coordinate in coordinates {
            for direction in INCREASING_UNIT_VECTORS {
                let line = Line(player, coordinate, direction, winLength)
                if isHit(line) {
                    ret.append(line) // No yeild statement. boo!
                }
            }
        }
        return ret
    }

    private func isHit(line: Line)-> Bool {
        for p in pointsFromLine(line) {
            if self.board[p]? != line.player {
                return false
            }
        }
        return true
    }
    
    func move(square: Point) {
        assert(getPlayerAt(square) == nil)
        board[square] = currentPlayer
        switch currentPlayer {
        case .X:
            currentPlayer = .O
        case .O:
            currentPlayer = .X
        }
        dispatchEvent()
    }
}


public enum Player {
    case X, O
}

public struct Point: Hashable{
    let x: Int, y: Int
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    func destructure()-> (x: Int, y: Int) {
        return (x, y)
    }
    
    public var hashValue: Int {
        get{
            return 31 &* x &+ y
        }
    }
}

//Line of points
public typealias Line = (player: Player, startingAt: Point, heading: Point, steps: Int)

public func pointsFromLine(line: Line)-> [Point] {
    var ret = [Point]()
    for d in 0..<line.steps {
        let x = line.startingAt.x + d * line.heading.x
        let y = line.startingAt.y + d * line.heading.y
        ret.append(Point(x:x, y:y))
    }
    return ret
}

public func==(lhs: Point, rhs:Point)-> Bool{
    return lhs.x == rhs.x && lhs.y == rhs.y
}

public func==(lhs: Line, rhs:Line)-> Bool{
    return lhs.player == rhs.player
        && lhs.heading == rhs.heading
        && lhs.startingAt == rhs.startingAt
}

//unit vectors that are all strictly increasing in at least 1 dimension
private func getIncreasingUnitVectors()->[Point] {
    var ret = generatePoints(-1...1, -1...1)
    ret = ret.filter { ($0.x == 1 || $0.y == 1) && ($0.x != 1 || $0.y != -1) }
    return ret
}
private let INCREASING_UNIT_VECTORS = getIncreasingUnitVectors()

func generatePoints(xRange: Range<Int>, yRange: Range<Int>) -> [Point] {
    var ret = [Point]()
    for x in xRange {
        for y in yRange {
            ret.append(Point(x:x, y:y))
        }
    }
    return ret
}