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
    var lastGoal: Int = 2000
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
    var boostTime: Int = 0
    var scene: GameScene!
    
    
    init(start: Int, view: GameScene, isExtreme: Bool, isClassic: Bool) {
        scene = view
        level = start
        score = 0
        extreme = isExtreme
        super.init()
        getNextGoal(current: start)
        board = BoardModel(difficulty: start, scene: view, includeBonuses: !isExtreme && !isClassic)
        displayBoard()
        resetTimer(true)
        
    }
    
    deinit {
        scene = nil
        print("GameModel memory freed")
    }
    
    func getNextGoal(current: Int){
        lastGoal = nextGoal
        nextGoal = current * 2000
        if( score >= nextGoal) {
            advanceLevel()
        }
    }
    func checkGoal() {
        if score >= nextGoal {
            advanceLevel()
        }
        else {
            print("S: \(score) N: \(nextGoal) L: \(lastGoal)")
            if level <= 1 {
                scene.run(scene.scoreMeter(score: self.score, maxScore: self.nextGoal))
                
            }
            else {
                scene.run(scene.scoreMeter(score: self.score - self.lastGoal, maxScore: self.nextGoal - self.lastGoal))
            }
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
        scene.ticker.removeAllActions()
        
        if(!timeStopped) {
            //scene.ticker.zRotation = 0
            scene.ticker.run(SKAction.rotate(toAngle: 0, duration: 2.9))
            stopTime(delay: 3, hard: true)  //Stops time for 3 seconds, then restarts the timer.
        } else {
            currTime = 0;
            scene.ticker.run(SKAction.rotate(toAngle: 0, duration: 0.5))//Time is already stopped, so simply reset the clock count so we don't cause race
            //conditions.
        }
        streak += 1
        //Check current "restore row" count. If enough, we restore a new row.
        if(streak >= streakRestore) {
            if( board.missingRows() > 0) {
                restoreRow()
            }
        }
        var actions: [SKAction] = []
        actions.append(scene.scoreMeter(score: 1, maxScore: 1))
        actions.append(scene.scoreMeter(score: 0, maxScore: 1))
        //print("S: \(score) N: \(nextGoal) L: \(lastGoal)")
        actions.append(scene.scoreMeter(score: self.score - self.lastGoal, maxScore: self.nextGoal - self.lastGoal))
        actions.append(SKAction.wait(forDuration: 0))
        scene.doSequencialActions(actions: actions, index: 0)
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
    /*
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
    */
    func rotateRow(row: Int, amount: Int, dir: direction)->Bool {
        let out = board.rotateRow(row: row, amount: amount, dir: dir)
        printBoard()
        if(out.success) {
            calculateScore(out.clears)
            if(extreme && board.missingRows() > 0) {
                restoreRow()
            }
        }
        return out.success
    }
    
    func getNextTime() -> TimeInterval {
        let cap: Int = 10
        let maxTimer : TimeInterval = 15
        let minTimer : TimeInterval = 10
        let extremeMax : TimeInterval = 10
        let extremeMin : TimeInterval = 3
        
        if(level >= cap) {
            return minTimer
        }
            
        else {
            if(extreme) {
                return extremeMax - TimeInterval(Int( (extremeMax - extremeMin / TimeInterval(cap)))  * (level - 1))
            }
            return maxTimer - TimeInterval( (Int( (maxTimer - minTimer) / TimeInterval(cap)))  * (level - 1))
        }
    }
    
    func  resetTimer(_ timeReset: Bool) {
        //Set the timer based on the current level.
        //Timer starts at a large amount and decreases each level, capping at a yet undetermined amount.
        timeLeft = getNextTime()
        if(timeReset) {
            scene.ticker.zRotation = 0
            scene.rotateTicker(duration: timeLeft)
            currTime = 0
        }
        print("Setting timer!")
        timeStopped = false
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: (#selector(timeTick)), userInfo: nil, repeats: true)
        //Re-initialize the actual timer.
    }
    
    @objc func softResetTimer() {
        resetTimer(false)
        var rot = -CGFloat(M_PI*2)
        if scene.rotation > CGFloat(M_PI) {
            rot = rot*2
        }
        print("SOFT: \(scene.rotation) ROT: \(rot)")
        scene.ticker.run(SKAction.rotate(toAngle: rot, duration: self.timeLeft-Double(self.currTime)))
        scene.redTime()
    }
    
    @objc func hardResetTimer() {
        resetTimer(true)
    }

    func stopTime(delay: Int, hard: Bool){
        timeStopped = true
        scene.rotation = scene.ticker.zRotation
        print("Stopping Time")

        timer.invalidate()
        if(hard) {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(delay), target: self, selector: (#selector(hardResetTimer)), userInfo: nil, repeats: false)
        }
        else {
            scene.ticker.removeAllActions()
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(delay), target: self, selector: (#selector(softResetTimer)), userInfo: nil, repeats: false)
        }
    }
    
    func restoreRow() {
        calculateScore(board.restoreRow())
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
        if !scene.abilityButton.isEnabled, UserDataHolder.shared.currentCharacter != nil, (UserDataHolder.shared.currentCharacter?.ability.abilityReady)! {
            scene.abilityButton.isEnabled = true
        }
        if boostTime == 1 {
            scene.redScore()
            pointValue = 50
        }
        if boostTime > 0{
            boostTime -= 1
        }
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
            scene.timeUp(timeLeft)
            printBoard()
        }
    }
    
    func indexColumns(_ col: [Int]) -> [BoardIndex] {
        var list = [BoardIndex]()
        for i in 0 ..< board.rowsLeft() {
            var colList = [BoardIndex]()
            for j in col {
                colList.append( (row: i, col: j))
            }
            list.append(contentsOf: colList)
        }
        return list
    }
    
    func indexRows(_ row: [Int]) -> [BoardIndex] {
        var list = [BoardIndex]()
        for i in row {
            if(i > board.rowsLeft() || i < 0) {
                continue
            }
            var rowList = [BoardIndex]()
            for j in 0..<board.numColumns() {
                
                rowList.append((row: i, col: j))
            }
            list.append(contentsOf: rowList)
        }
        return list
    }
    
    
    func indexAdjacent(idx: BoardIndex, cardinalOnly: Bool, dist: Int) -> [BoardIndex]{
        var list = [BoardIndex]()
        if(idx.row > board.rowsLeft() - 1) {
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
    

    func indexRandom(_ probability: Int) -> [BoardIndex] {
        var list = [BoardIndex]()
        if(probability > 100 || probability < 0) {
            print("Warning: Invalid probability sent to Index Random. Must be between 0 and 100")
        }
        for i in 0..<board.rowsLeft() {
            for j in 0..<board.numColumns() {
                let index = Int(arc4random_uniform(UInt32(100)))
                if(index <= probability) {
                    list.append((row: i, col: j))
                }
            }
        }
        return list
    }
    
    
    func indexType(_ type:  pieceType) -> [BoardIndex] {
        var list = [BoardIndex]()
        for i in 0..<board.rowsLeft() {
            for j in 0..<board.numColumns() {
                if(board.getPiece(index: (row: i, col: j)).getType() == type) {
                    list.append( (row: i, col: j))
                }
            }
        }
        return list
    }
    
    func trySpecial(row: Int, col: Int) -> Bool{
        for i in UserDataHolder.shared.unlockedBonuses{
            if board.getPiece(index: BoardIndex(row: row, col: col)).getType() == i.getPieceType() {
                i.doBonus(row: row, col: col)
                return true
            }
        }
        return false

    }
    
    func runAbilityStopwatchAnimation(duration: TimeInterval){
        scene.rotateAbilityTicker(duration: duration)
    }
    
    func setBomb() {
        scene.bombMode = true
    }
    
    func bomb(idx: BoardIndex, size: Int) {
        var sound = SKAction.wait(forDuration: 0)
        if board.getPiece(index: idx).getType() != pieceType.Money {
            sound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
        }
        let list = indexAdjacent(idx: idx, cardinalOnly: false, dist: size)
        var actions = board.clearPieces(list: list)
        actions.append(SKAction.wait(forDuration: 0))
        scene.run(sound)
        scene.doSequencialActions(actions: actions, index: 0)
        _ = board.update()
        updateScore(pointValue * list.count)
    }
    
    func clusterBomb(_ probability: Int) {
        let list = indexRandom(probability)
        var actions = board.clearPieces(list: list)
        actions.append(SKAction.wait(forDuration: 0))
        if actions.count > 0 {
            scene.run(SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false))
        }
        scene.doSequencialActions(actions: actions, index: 0)
        _ = board.update()
        updateScore((pointValue) * list.count)
    }
    
    func clearBottomRow(_ amount: Int) {
        var rows = [Int]()
        for i in 0 ..< amount {
            let rowNum = board.rowsLeft() - 1 - i
            if(rowNum >= 0) {
                rows.append(rowNum)
            }
        }
        let list = indexRows(rows)
        var actions = board.clearPieces(list: list)
        actions.append(SKAction.wait(forDuration: 0))
        scene.doSequencialActions(actions: actions, index: 0)
        _ = board.update()
        updateScore((pointValue / 2) * list.count)
    }
    
    func clearCenterColumn(_ amount: Int) {
        var columns = [Int]()
        let mid : Int = Int(Double(board.numColumns()) / 2.0)
        columns.append(mid)
        for i in 1 ..< amount {
            if(i <= mid) {
                columns.append(mid - i)
                if(i != mid) {
                    columns.append(mid + i)
                }
            }
        }
        let list = indexColumns(columns)
        var actions = board.clearPieces(list: list)
        actions.append(SKAction.wait(forDuration: 0))
        scene.doSequencialActions(actions: actions, index: 0)
        _ = board.update()
        updateScore((pointValue) * list.count)
    }
    
    func pointBoost(duration: TimeInterval, pointValue: Int) {
        //print("BOOSTED")
        self.pointValue = pointValue
        self.boostTime = Int(duration)
    }
    
    func teleport() {
        scene.teleportMode = true
    }
    
    func teleMove(_ first: BoardIndex, _ second: BoardIndex) {
        let res = board.teleSwap(first, second)
        if(res.success) {
            calculateScore(res.clears)
        }
    }
    
    func calculateScore(_ list: [Int]){
        var total = 0
        var multiplier = 1.0
        for i in list {
            let combomult = 1 + (0.25 * Double(i - 3))
            total += Int(Double(pointValue) * (Double(i) * combomult) * multiplier)
            print(pointValue,"->",i,"->",combomult,"->",multiplier,"->",total)
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
        board = nil
        over = true
        timer.invalidate()
        scene.quitButton.sendActions(for: UIControlEvents.touchUpInside)
    }
    
    /*
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
    */

//    func startGame(diff: Int, frame: CGRect) {
//        //gameBoard = BoardModel()
//        //gameBoard.generatePieces(difficulty: diff, frame: frame)
//    }
 }

