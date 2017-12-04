 //
//  GameModel.swift
//  Switch Personal
//
//  Created by Maurice Baldain on 11/15/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit
import CoreData
import SpriteKit
import GameplayKit

class GameModel: NSObject {
    var board: BoardModel!
    var level : Int	//The current level of difficulty, integer from 1 to an arbitrary amount
    var score : Int
    var nextGoal: Int = 2000
    var streak: Int = 0
    var timeLeft : TimeInterval = 90
    var timer : Timer = Timer()
    var totalTime : Int = 0
    var currTime : Int = 0
    var tooLong : Bool = false
    var pointValue: Int = 50
    var timeStopped: Bool = true
    var extreme: Bool = false
    var over: Bool = false
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
        resetTimer(true)
        
    }
    
    func getNextGoal(current: Int){
        nextGoal = current * 2000
        if( score >= nextGoal) {
            advanceLevel()
        }
    }
    func checkGoal() {
        if score >= nextGoal {
            advanceLevel()
        }
    }
    
    //*
//    func createGameScene() -> GameScene{
//        
//    }
    
    func advanceLevel() {
        print("LEVEL UP!")
        let streakRestore: Int = 3
        level += 1
        print("Got to level \(level)!")
        board.advanceLevel()
        getNextGoal(current: level)
        if(!timeStopped) {
            stopTime(delay: 3, hard: true)  //Stops time for 3 seconds, then restarts the timer.
        }
        streak += 1
        //Check current "restore row" count. If enough, we restore a new row.
        if(streak >= streakRestore) {
            if( board.missingRows() > 0) {
                restoreRow()
            }
        }
    }
    
    func makeMove(move: Move) -> Bool{
        if(move.index.row >= board.rowsLeft()) {
            return false
        }
        let out = board.makeMove(move: move)
        
        if(out.success) {
            calculateScore(out.clears)
            //Only for Extreme?
            if(extreme && board.missingRows() > 0) {
                restoreRow()
            }
        }
        
        return out.success
    }
    
    func makeRowMove(moves: [Move]) -> Bool{
        let out = board.makeMoveForRow(moves: moves)
        
        if(out.success) {
            calculateScore(out.clears)
            //Only for Extreme?
            if(extreme && board.missingRows() > 0) {
                restoreRow()
            }
        }
        
        return out.success
    }
    
    func rotateRow(row: Int, amount: Int, dir: direction)->Bool {
        let out = board.rotateRow(row: row, amount: amount, dir: dir)
        printBoard()
        if(out.success) {
            calculateScore(out.clears)
        }
        return out.success
    }
    
    func getNextTime() -> TimeInterval {
        let cap: Int = 10
        let maxTimer : TimeInterval = 15
        let minTimer : TimeInterval = 10
        if(level >= cap) {
            return minTimer
        }
        else {
            return maxTimer - TimeInterval( (Int( (maxTimer - minTimer) / TimeInterval(cap)))  * (level - 1))
        }
    }
    
    func  resetTimer(_ timeReset: Bool) {
        //Set the timer based on the current level.
        //Timer starts at a large amount and decreases each level, capping at a yet undetermined amount.
        timeLeft = getNextTime()
        if(timeReset) {
            currTime = 0
        }
        print("Setting timer!")
        timeStopped = false
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: (#selector(timeTick)), userInfo: nil, repeats: true)
        //Re-initialize the actual timer.
    }
    
    @objc func softResetTimer() {
        resetTimer(false)
    }
    
    @objc func hardResetTimer() {
        resetTimer(true)
    }

    func stopTime(delay: Int, hard: Bool){
        timeStopped = true
        print("Stopping Time")

        timer.invalidate()
        if(hard) {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(delay), target: self, selector: (#selector(hardResetTimer)), userInfo: nil, repeats: false)
        }
        else {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(delay), target: self, selector: (#selector(softResetTimer)), userInfo: nil, repeats: false)
        }
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
        if(totalTime >= Int.max - 1) {
            totalTime = 0
            tooLong = true
        }
        totalTime += 1
        currTime += 1
        //print("Tick")
        //print(currTime)
        if(currTime >= Int(timeLeft)) {
            currTime = 0
            timeUp()
        }
    }
    
    
    func timeUp() {
        print("\(board.rowsLeft()) rows left.")
        if(board.rowsLeft() <= 2){
            gameOver()
        }else {
            streak = 0
            board.removeRow()
            //scene.removeBottomRow()
            scene.curArrow = nil
            scene.lastDirection = nil

            scene.touchesEnded(scene.lastSet, with: scene.lastEvent)
            printBoard()
        }
        
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
        if(idx.row >= board.rowsLeft() - 1) {
            return list
        }
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
        let list = indexAdjacent(idx: idx, cardinalOnly: false, dist: size)
        board.clearPieces(list: list)
        _ = board.update()
        updateScore(pointValue * list.count)
    }
    
    
    func calculateScore(_ list: [Int]){
        var total = 0
        var multiplier = 1.0
        for i in list {
            let combomult = 1 + (0.25 * Double(i - 3))
            total += Int(Double(pointValue) * (Double(i) * combomult) * multiplier)
            multiplier += 0.5
        }
        print()
        updateScore(total)
    }
    
    func updateScore(_ points: Int) {
        
        score += points
        print("Worth \(points) points! You have  You have \(score) points, and the next level is at \(nextGoal)")
        checkGoal()
        scene.updateScore(score: score)
    }
    
    func gameOver() {
        if(tooLong) {
            print("Game Over! You lasted for over 292 billion years, somehow! Otherwise, there was some kind of horrible glitch!")
        } else {
            print("Game Over! You lasted \(totalTime) seconds! Your total score was \(score)!")
        }
//<<<<<<< HEAD
        //Saving the time and score
        //saveScoreAndTime() //Compares scores and stores them if they are better than previous
        //Done Saving the time and score
        //board = nil
//=======
        board = nil
        over = true
//>>>>>>> origin/Baldain
        timer.invalidate()
        scene.quitButton.sendActions(for: UIControlEvents.touchUpInside)
    }
    
    func saveScoreAndTime() {

        let currentBestScore = UserDefaults.standard.integer(forKey: UserDataHolder.shared.BEST_SCORE_KEY)
        if score > currentBestScore {
            UserDefaults.standard.set(score, forKey: UserDataHolder.shared.BEST_SCORE_KEY)
            print("You have beat your previous score of \(currentBestScore)")
        }
        
        let currentBestTime = UserDefaults.standard.integer(forKey: UserDataHolder.shared.BEST_TIME_KEY)
        if totalTime > currentBestTime {
            UserDefaults.standard.set(totalTime, forKey: UserDataHolder.shared.BEST_TIME_KEY)
            print("You have beat your previous time of \(currentBestTime)")
        }
    }

//    func startGame(diff: Int, frame: CGRect) {
//        //gameBoard = BoardModel()
//        //gameBoard.generatePieces(difficulty: diff, frame: frame)
//    }
}
