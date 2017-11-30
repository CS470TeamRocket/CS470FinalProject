//
//  GameModel.swift
//  Switch Personal
//
//  Created by Maurice Baldain on 11/15/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameModel: NSObject {
    var board: BoardModel!
    var level : Int	//The current level of difficulty, integer from 1 to an arbitrary amount
    var score : Int
    var nextGoal: Int = 1000
    var streak: Int = 0
    var timeLeft : TimeInterval = 90
    var timer : Timer = Timer()
    var totalTime : Int = 0
    var currTime : Int = 0
    //*
    var scene: GameScene!
    
    
    init(start: Int, view: GameScene) {
        scene = view
        level = start
        score = 0
        super.init()
        getNextGoal(current: start)
        board = BoardModel(difficulty: start, scene: view)
        displayBoard()
        resetTimer()
        
    }
    
    func getNextGoal(current: Int){
        nextGoal = current * 1000
        if( score >= nextGoal) {
            advanceLevel()
        }
    }
    //*
//    func createGameScene() -> GameScene{
//        
//    }
    
    func advanceLevel() {
        let streakRestore: Int = 3
        level += 1
        board.advanceLevel()
        getNextGoal(current: level)
        timeLeft = getNextTime()
        currTime = 0
        streak += 1
        //Check current "restore row" count. If enough, we restore a new row.
        if(streak >= streakRestore) {
            if( board.missingRows() > 0) {
                restoreRow()
            }
        }
    }
    
    func makeMove(move: Move) -> Bool{
        return board.makeMove(move: move)
    }
    
    func rotateRow(row: Int, amount: Int, dir: direction)->Bool {
        let out = board.rotateRow(row: row, amount: amount, dir: dir)
        printBoard()
        return out
    }
    
    func getNextTime() -> TimeInterval {
        let cap: Int = 3
        let maxTimer : TimeInterval = 10
        let minTimer : TimeInterval = 5
        if(level >= cap) {
            return minTimer
        }
        else {
            return maxTimer - TimeInterval(1 * (level - 1))
        }
    }
    
    func resetTimer() {
        //Set the timer based on the current level.
        //Timer starts at a large amount and decreases each level, capping at a yet undetermined amount.
        timeLeft = getNextTime()
        print("Setting timer!")
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: (#selector(timeTick)), userInfo: nil, repeats: true)
        //Re-initialize the actual timer.
    }
    
    func stopTime(delay: Int){
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(delay), target: self, selector: (#selector(resetTimer)), userInfo: nil, repeats: false)
    }
    
    func restoreRow() {
        board.restoreRow()
    }
    
    func printBoard() {
        board.printBoard()
        print("")
    }
    
    func displayBoard() {
        scene.makeBoard(board: board.getBoard())
    }
    
    func updateTimeBar(timePercent: Double) {
        //This will be used to update the graphic bar representing the time left for each round.
        //Takes a double representing a percentage of the bar that should be filled.
    }
    
    @objc func timeTick() {
        totalTime += 1
        currTime += 1
        //print("Current Time:", currTime, "\tTotal Time:", totalTime)
        if(currTime >= Int(timeLeft)) {
            //print("Time to reset timer.")
            currTime = 0
            timeUp()
        }
    }
    
    func timeUp() {
        if(board.rowsLeft() <= 1){
            gameOver()
        }else {
            streak = 0
            //board.removeRow()
            //scene.removeBottomRow()
            //printBoard()
        }
        
    }
    
    func indexRow(row: Int) -> [BoardIndex] {
        var list = [BoardIndex]()
        for i in 0 ..< board.numColumns() {
            list.append( (row: row, col: i))
        }
        return list
    }
    
    func indexColumn(col: Int) -> [BoardIndex] {
        var list = [BoardIndex]()
        for i in 0 ..< board.rowsLeft() {
            list.append( (row: i, col: col))
            list.append(contentsOf: list)
        }
        
        return list
    }
    
    func indexAdjacent(idx: BoardIndex, cardinalOnly: Bool, dist: Int) -> [BoardIndex]{
        var list = [BoardIndex]()
        
        let minX = idx.col - dist < 0 ? 0 : idx.col - dist
        let maxX = idx.col + dist >= board.numColumns() ? board.numColumns() - 1 : idx.col + dist
        
        let minY = idx.row - dist < 0 ? 0 : idx.row - dist
        let maxY = idx.row + dist >= board.rowsLeft() ? board.rowsLeft() - 1: idx.row + dist
        
        for i in minX ... maxX {
            for j in minY ... maxY {
                if(!cardinalOnly || (i == idx.col || j == idx.row) ) {
                    list.append((row: j, col: i))
                }
            }
        }
        return list
    }
    
    func bomb(idx: BoardIndex, size: Int) {
        board.clearPieces(list: indexAdjacent(idx: idx, cardinalOnly: false, dist: size))
    }
    
    func gameOver() {
        print("Game Over! You lasted \(totalTime) seconds!")
        timer.invalidate()
    }
    
    
}
//    func startGame(diff: Int, frame: CGRect) {
//        //gameBoard = BoardModel()
//        //gameBoard.generatePieces(difficulty: diff, frame: frame)
//    }
//}
