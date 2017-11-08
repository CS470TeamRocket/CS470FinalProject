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
	private var nextGoal: Int
	private var streak: Int
	private var timeLeft : TimeInterval
	
	func init(start: Int) {
		level = start
		score = 0
		super.init()
		nextGoal = getNextGoal(current: start)
		board = BoardModel(start)
		resetTimer()
	}
	
	func getNextGoal(current: Int) {
		nextGoal = current * 1000
		if( score >= nextGoal) {
			advanceLevel() 
		}
	}
	
	func advanceLevel() {
		let streakRestore: Int = 3
		level += 1
		board.advanceLevel()
		getNextGoal()
		
		resetTimer()
		
		//Check current "restore row" count. If enough, we restore a new row.
		if(streak >= streakRestore) {
			if( board.missingRows() > 0) {
				restoreRow()
			}
		}
	}
	
	func resetTimer() {
	//Set the timer based on the current level.
	//Timer starts at a large amount and decreases each level, capping at a yet undetermined amount.
	
		let cap: Int = 10
		let maxTimer : TimeInterval = 300
		let minTimer : TimeInterval = 30
		if( level >= cap) {
			timeLeft = minTimer
		}
		else {
			timeLeft = maxTimer - ( (level - 1) * 30)
		}
		
		//Re-initialize the actual timer.
	}
	
	func restoreRow() {
		board.restoreRow()
	}


}