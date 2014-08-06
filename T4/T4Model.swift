//
//  Model.swift
//
//  Created by Amit D. Bansil on 7/20/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

//Enumerations, Yay!
public enum Player {
    case X, O
}

//Structs are copied whenever passed rather than being passed by reference
public struct Point: Hashable{
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
public typealias Line = (player: Player, startingAt: Point, heading: Point)

//operator overloading. Yay!
public func==(lhs: Point, rhs:Point)-> Bool{
    return lhs.x == rhs.x && lhs.y == rhs.y
}

public func==(lhs: Line, rhs:Line)-> Bool{
    return lhs.player == rhs.player
        && lhs.heading == rhs.heading
        && lhs.startingAt == rhs.startingAt
}

public class Model: Observable { //OOP w/o multiple inheritance. Yay!
    private var board = [Point:Player]() // Built in dictionary syntax & type inference.
    private(set) var currentPlayer: Player
    let winLength: Int
    let width: Int, height: Int
    
    init(width: Int, height: Int, winLength: Int) {
        self.winLength = winLength
        self.width = width
        self.height = height
        currentPlayer = Player.X
    }
    
    var coordinates: [Point] {
    get{
        return generatePoints(0..<width, 0..<height)
    }
    }
    
    func getPlayerAt(point: Point)-> Player? {
        return board[point]
    }
    
    private var oldHits = [Line]()
    var hits: [Line] {
    get {
        //make sure that any new hits are appended to the array of existing hits
        var ret = [Line]()
        ret += getHitLines(.X) //infer 
        ret += getHitLines(.O)
        
        for oldLine in oldHits {
            ret = ret.filter(){ !($0 == oldLine) }
        }
        
        oldHits += ret
        
        return oldHits
    }
    }
    
    func getHitLines(player: Player)-> [(Line)]{
        var ret = [(Line)]()
        for coordinate in coordinates {
            for direction in INCREASING_UNIT_VECTORS {
                let line = Line(player, coordinate, direction)
                if isWinningLine(line) {
                    ret += line // No yeild statement. boo!
                }
            }
        }
        return ret
    }
    
    public func pointsFromLine(line: Line)-> [Point] {
        var ret = [Point]()
        for d in 0..<winLength {
            let x = line.startingAt.x + d * line.heading.x
            let y = line.startingAt.y + d * line.heading.y
            ret += Point(x:x, y:y)
        }
        return ret
    }

    func isWinningLine(line: Line)-> Bool {
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
            ret += Point(x:x, y:y)
        }
    }
    return ret
}