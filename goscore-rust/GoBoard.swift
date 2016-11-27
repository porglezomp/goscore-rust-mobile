//
//  GoBoard.swift
//  goscore-rust
//
//  Created by Caleb Jones on 11/26/16.
//  Copyright © 2016 Caleb Jones. All rights reserved.
//

import Foundation

class GoBoard {
    
    private var board: RawGoBoard
    var width: UInt {
        get { return UInt(board.width) }
    }
    var height: UInt {
        get { return UInt(board.height) }
    }
    
    init() {
        board = RawGoBoard()
    }
    
    init(width: UInt, height: UInt) {
        self.board = RawGoBoard(width: size_t(width), height: size_t(height))
    }
    
    init(stones: [Stone], width: UInt, height: UInt) {
        self.board = RawGoBoard(buffer: stones.map { $0.value },
                                width: size_t(width), height: size_t(height))
    }
    
    subscript(idx: (UInt, UInt)) -> Stone {
        get {
            return Stone(self.board.rawValue(atRow: uint(idx.0), column: uint(idx.1)))
        }
        set {
            self.board.setRawValueAtRow(uint(idx.0), column: uint(idx.1), value: newValue.value)
        }
    }
    
    func guessDeadStones() {
        self.board.guessDeadStones()
    }
    
    func scoreStones() {
        self.board.scoreStones()
    }
    
    func scoreSums(komi: UInt) -> (blackScore: UInt, whiteScore: UInt, winner: Color) {
        var blackScore: uint = 0
        var whiteScore: uint = 0
        let winner = self.board.scoreSums(withKomi: uint(komi), blackScore: &blackScore, whiteScore: &whiteScore)
        return (UInt(blackScore),
                UInt(whiteScore),
                winner == 0 ? .black : .white)
    }
    
}

fileprivate let GO_STONE_PRESENCE: CChar = 0x1
fileprivate let GO_STONE_COLOR: CChar = 0x2
fileprivate let GO_STONE_DEAD: CChar = 0x4
fileprivate let GO_STONE_SCORE: CChar = 0x8
fileprivate let GO_STONE_SCORE_COLOR: CChar = 0x10

enum Color {
    case black
    case white
}

struct Stone {
    
    fileprivate var value: CChar = 0
    
    fileprivate init(_ value: CChar) {
        self.value = value
    }
    
    init() {
        self.init(0)
    }
    
    init(color: Color) {
        self.init()
        self.color = color
    }
    
    private nonmutating func get(bit: CChar) -> Bool {
        return (self.value & bit) != 0
    }
    
    private mutating func set(bit: CChar, to isSet: Bool) {
        if isSet {
            self.value |= bit
        } else {
            self.value &= ~bit
        }
    }
    
    var present: Bool {
        get { return self.get(bit: GO_STONE_PRESENCE) }
        set { self.set(bit: GO_STONE_PRESENCE, to: newValue) }
    }
    
    var dead: Bool {
        get { return self.present && self.get(bit: GO_STONE_DEAD) }
        set { self.set(bit: GO_STONE_DEAD, to: newValue) }
    }
    
    var color: Color? {
        get {
            if self.present {
                if self.get(bit: GO_STONE_COLOR) {
                    return .white
                } else {
                    return .black
                }
            } else {
                return nil
            }
        }
        set {
            switch newValue {
            case .none:
                self.present = false
            case .some(.black):
                self.present = true
                self.set(bit: GO_STONE_COLOR, to: false)
            case .some(.white):
                self.present = true
                self.set(bit: GO_STONE_COLOR, to: true)
            }
        }
    }
    
    var score: Color? {
        get {
            if self.get(bit: GO_STONE_SCORE) {
                if self.get(bit: GO_STONE_SCORE_COLOR) {
                    return .white
                } else {
                    return .black
                }
            } else {
                return nil
            }
        }
        set {
            switch newValue {
            case .none:
                self.set(bit: GO_STONE_SCORE, to: false)
            case .some(.black):
                self.set(bit: GO_STONE_SCORE, to: true)
                self.set(bit: GO_STONE_SCORE_COLOR, to: false)
            case .some(.white):
                self.set(bit: GO_STONE_SCORE, to: true)
                self.set(bit: GO_STONE_SCORE_COLOR, to: true)
            }
        }
    }
    
}
