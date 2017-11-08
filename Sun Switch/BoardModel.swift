//
//  BoardModel.swift
//  Sun Switch
//
//  Created by Maurice Baldain on 11/7/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation

class BoardModel: NSObject {
	private let rows: Int = 5 // Number of starting Rows. The number of columns is determined in the RowModel
	private var currentRows : Int = 5 // Current number of rows. This cannot exceed rows
	private var board : [RowModel]()
	private var diff : Int
	private var validPieces : [PieceModel]()	//The roster of available pieces. This is based
												//on the current level.
	func init(difficulty: Int) {
		diff = (difficulty <= 0 ) ? 1 : difficulty
		super.init()
		generatePieces(startLevel: diff)
		generateBoard(startLevel: diff)
	}
	
	func generatePieces(startLevel: Int) {
		//This uses the difficulty level to select a number of piece types to add to the
		//roster of available pieces. This will be pretty hard-coded, unfortunately.
		
	}
	func generateBoard(startLevel: Int) {
		//Later: Differentiate build based on starting levels
		//This is used to create a new board, based on starting level.
		
		for i in 0..<rows {
			board.append(createRow()) 
		}
		
	}
	
	func newPiece() -> PieceModel{
		//This should hopefully create a new piece based off the type chosen at random.
		
		let index = arc4random_uniform(validPieces.count)
		let piece_type: PieceModel.Type = validPieces[index].self
		return piece_type.init()
	}
	
	func advanceLevel() {
		//Advance board level.
		//As the level progresses, this will unlock new available pieces, including potential 
		//negative pieces (unbreakable blocks, etc)
		
		diff += 1
		
	}
	
	func restoreRow() {
		let row = createRow()
		board.append(row)
		currentRows += 1
		//Any other cleanup we might need.
	}
	
	func createRow() -> RowModel{
		let row = RowModel()
		row.populate(pieceList: validPieces)
		return row
}