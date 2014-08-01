//
//  Model.swift
//  T4
//
//  Created by Amit D. Bansil on 7/20/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

//Enumerations, Yay!
public enum T4Player {
    case X, O
}

//Structs are copied whenever passed rather than being passed by reference
public struct T4Point: Hashable{
    //let defines a constant and is the preferred way of naming a value instead of var
    let x: Int, y: Int
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    func destructure()-> (x: Int, y: Int) { //built in tuple type. Yay!
        return (x, y)
    }
    
    public var hashValue: Int {
    get{
        return 31 &* x &+ y // overflow-tastic (arithmetic is checked by default. yay!)
    }
    }
}
//type alias's make tuples more useful
public typealias T4Line = (player: T4Player, startingAt: T4Point, heading: T4Point)

//operator overloading. Yay!
public func==(lhs: T4Point, rhs:T4Point)-> Bool{
    return lhs.x == rhs.x && lhs.y == rhs.y
}

public func==(lhs: T4Line, rhs:T4Line)-> Bool{
    return lhs.player == rhs.player
        && lhs.heading == rhs.heading
        && lhs.startingAt == rhs.startingAt
}

public class T4Model: Observable { //OOP w/o multiple inheritance. Yay!
    private var board = [T4Point:T4Player]() // Built in dictionary syntax & type inference.
    private(set) var currentPlayer: T4Player
    let winLength: Int
    let width: Int, height: Int
    
    init(width: Int, height: Int, winLength: Int) {
        self.winLength = winLength
        self.width = width
        self.height = height
        currentPlayer = T4Player.X
    }
    
    var coordinates: [T4Point] {
    get{
        return generatePoints(0..<width, 0..<height)
    }
    }
    
    func getPlayerAt(point: T4Point)-> T4Player? {
        return board[point]
    }
    
    private var oldHits = [T4Line]()
    var hits: [T4Line] {
    get {
        //make sure that any new hits are appended to the array of existing hits
        var ret = [T4Line]()
        ret += getHitLines(.X) //infer 
        ret += getHitLines(.O)
        
        for oldLine in oldHits {
            ret = ret.filter(){ !($0 == oldLine) }
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
                    ret += line // No yeild statement. boo!
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
            ret += T4Point(x:x, y:y)
        }
        return ret
    }

    func isWinningLine(line: T4Line)-> Bool {
        for p in pointsFromLine(line) {
            if self.board[p]? != line.player {
                return false
            }
        }
        return true
    }
    
    func move(square: T4Point) {
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

//unit vectors that are all strictly increasing in at least 1 dimension
private func getIncreasingUnitVectors()->[T4Point] {
    var ret = generatePoints(-1...1, -1...1)
    ret = ret.filter { ($0.x == 1 || $0.y == 1) && ($0.x != 1 || $0.y != -1) }
    return ret
}
private let INCREASING_UNIT_VECTORS = getIncreasingUnitVectors()

func generatePoints(xRange: Range<Int>, yRange: Range<Int>) -> [T4Point] {
    var ret = [T4Point]()
    for x in xRange {
        for y in yRange {
            ret += T4Point(x:x, y:y)
        }
    }
    return ret
}