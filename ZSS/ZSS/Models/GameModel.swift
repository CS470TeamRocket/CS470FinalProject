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
    
    func restoreRow() {
        board.restoreRow()
    }
    func printBoard() {
        //board.printBoard()
        print("")
    }
    
    func displayBoard() {
        scene.makeBoard(board: board.getBoard())
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