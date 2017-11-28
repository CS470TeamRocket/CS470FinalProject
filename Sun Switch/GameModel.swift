//
//  GameModel.swift
//  Sun Switch
//
//  Created by Maurice Baldain on 11/7/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation

class GameModel: NSObject {
	private var board : BoardModel!
	private var level : Int	//The current level of difficulty, integer from 1 to an arbitrary amount
	private var score : Int
	private var nextGoal: Int = 1000
	private var streak: Int = 0
	private var timeLeft : TimeInterval = 90
    private var timer : Timer = Timer()
    private var totalTime : Int = 0
    private var currTime : Int = 0
    private var scene: GameScene
    

    init(start: Int, view: GameScene) {
        scene = view
		level = start
		score = 0
        super.init()
		getNextGoal(current: start)
        board = BoardModel(difficulty: start)
		resetTimer()
        
	}
	
	func getNextGoal(current: Int){
		nextGoal = current * 1000
		if( score >= nextGoal) {
			advanceLevel() 
		}
	}
	
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
        board.printBoard()
        print("")
    }
    
    func displayBoard(display: GameScene) {
        //GameScene.createSprites(board.getBoard())
    }
    
    @objc func timeTick() {
        totalTime += 1
        currTime += 1
        updateTimeBar( timePercent: (timeLeft - Double(currTime)) / timeLeft )
        if(currTime >= Int(timeLeft)) {
            currTime = 0
            timeUp()
        }
    }
    
    func updateTimeBar(timePercent: Double) {
        //This will be used to update the graphic bar representing the time left for each round.
        //Takes a double representing a percentage of the bar that should be filled.
    }
    
    func timeUp() {
        if(board.rowsLeft() <= 1){
            gameOver()
        }else {
            streak = 0
            board.removeRow()
            printBoard()
        }
    }
    
    func gameOver() {
        print("Game Over! You lasted \(totalTime) seconds!")
        timer.invalidate()
    }
    
}
