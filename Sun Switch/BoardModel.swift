//
//  BoardModel.swift
//  Sun Switch
//
//  Created by Maurice Baldain on 11/7/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation
enum direction {
	case left
	case right
	case up
	case down
}

typealias BoardIndex = (row: Int, col: Int)
typealias Move = (index: BoardIndex, dir: direction)

class BoardModel: NSObject {
	private let rows: Int = 8 // Number of starting Rows. The number of columns is determined in the RowModel
	private var currentRows : Int = 8 // Current number of rows. This cannot exceed rows
    private var columns : Int = 8
	private var board : [RowModel] = [RowModel]()
	private var diff : Int
	private var validPieces : [pieceType] = [pieceType]()	//The roster of available pieces. This is based
												//on the current level.
	init(difficulty: Int) {
		diff = (difficulty <= 0 ) ? 1 : difficulty
		super.init()
		generatePieces()
		generateBoard()
        let matchList = checkAll()
        for i in 0 ..< matchList.count {
            print(matchList[i])
        }
        update()
	}
	
	func generatePieces() {
		//This uses the difficulty level to select a number of piece types to add to the
		//roster of available pieces. This will be pretty hard-coded, unfortunately.
        validPieces = pieceType.Empty.validPieces(level: diff)
	}
    
	func generateBoard() {
		//Later: Differentiate build based on starting levels
		//This is used to create a new board, based on starting level.
		
		for i in 0 ..< rows {
            let isLast = (i == rows - 1 ) ? true : false
            board.append(createRow(count: i, isLast: isLast))
		}
		
	}
    func getBoard() ->[RowModel] {
        return board
    }
    
	func newPiece() -> PieceModel{
		//This should hopefully create a new piece based off the type chosen at random.
		
        return PieceModel(valid: validPieces)
	}
    
	
	func advanceLevel() {
		//Advance board level.
		//As the level progresses, this will unlock new available pieces, including potential 
		//negative pieces (unbreakable blocks, etc)
		
		diff += 1
        generatePieces()
		
	}
	
	func restoreRow() {
        board.last!.setLast(val: false)
        let row = createRow(count: currentRows + 1, isLast: true)
		board.append(row)
		currentRows += 1
		//Any other cleanup we might need.
	}
    
    
    func removeRow() {
        //Removes the row from the board, occurs only when the sun expands.
        if(currentRows <= 1) {
            print("Error in removal!")
            return
        }
        board.removeLast()
        board.last!.setLast(val: true)
        currentRows -= 1
    }
    func createRow(count: Int, isLast: Bool) -> RowModel{
        let row = RowModel(row: count, col: columns, last: isLast)
        for _ in 0 ..< columns {
            row.addPiece(piece: newPiece())
        }
		return row
    }
    func missingRows() -> Int {
        if(currentRows < rows) {
            return rows - currentRows
        }
        return 0
    }
    
    func rowsLeft() -> Int {
        return currentRows
    }
    
    func printBoard() {
        for i in 0 ..< currentRows {
            board[i].printRow()
        }
    }
    func rotateRow(row: Int, dir: direction )-> Bool{
		if(row < rows) {
            board[row].rotate(dir: dir)
			return true
		}
		else {
			return false
		}
	}
	
	func checkAll() -> [BoardIndex]{
		var matched = [BoardIndex]()
		for i in 0 ..< rows {
			for j in 0 ..< columns {
                if(checkMatch(index: (i, j))) {
					matched.append((i,j))
				}
			}
		}
        return matched
	}
	
	func getPiece(index: BoardIndex) -> PieceModel {
        return board[index.row].getPiece(col: index.col)
	}
	
	func checkMatch(index: BoardIndex)->Bool {
        return scanVert(index: index) >= 3 || scanHoriz(index: index) >= 3
	}
	
	func scanVert(index: BoardIndex) -> Int {
		let row = index.row 
		let col = index.col
		var matchSize = 1
        let piece = getPiece(index: index)
		var matched = true
		var i = 1
		//Check above
		while(row-i >= 0 && matched) {
            if(piece.isMatching(other: getPiece(index: (row-i, col)))) {
				matchSize += 1
			} else {
				matched = false
			}
			i += 1
		}
		
		//Check below 
		i = 1
		matched = true
		while(row+i < rows && matched) {
            if(piece.isMatching(other: getPiece(index: (row+i, col)))) {
				matchSize += 1
			} else {
				matched = false
			}
			i += 1
		}
			
		return (matchSize >= 3) ? matchSize : 0
	}
    
    func makeMove(move: Move) ->Bool {
        if(checkMove(move: move)) {
            swap(move: move)
            update()
            return true
        }
        return false
    }
    
    func update() {
        while(checkAll().count > 0) {
            clearPieces(list: checkAll())
        }
    }
    
    func checkMove(move: Move) -> Bool {
        let newIndex = swap(move: move)
        let isMatch = checkMatch(index:move.index) || checkMatch(index: newIndex)
        swap(move: move)
        return isMatch
    }
    
    func updateColumn(col: Int) {
        var i = rows-1
        var j = rows-2
        while(i >= 0) {
            let piece = getPiece(index:(i, col))

            if (piece.isEmpty()) {
                var filled : Bool = false
                
                while(j >= 0 && !filled ) {
                    let replace = getPiece(index: (j, col))
                    if !replace.isEmpty() {
                        piece.swap(new: replace)
                        filled = true
                    }
                    j -= 1
                }
                
                if (!filled) {
                    piece.genType(valid: validPieces)
                }
                
            }
            
            i -= 1
            if(j >= i) {
                j = i - 1
            }
            
        }
    }
    
    
    func swap(move: Move) -> BoardIndex {
        var offsetX = move.index.col
        var offsetY = move.index.row
        switch (move.dir) {
        case direction.up:
            offsetY = -1
        case direction.down:
            offsetY = 1
        case direction.left:
            offsetX = -1
        case direction.right:
            offsetX = 1
        }
        
        getPiece(index: move.index).swap(new: getPiece(index: (offsetY, offsetX)))
        return (offsetY, offsetX)
    }
    func clearPieces(list: [BoardIndex]) {
        for idx in list {
            let piece = getPiece(index: idx)
            piece.clear()
        }
        for i in 0 ..< columns {
            //printBoard()
            //print("")
            updateColumn(col: i)
        }
    }
	func scanHoriz(index: BoardIndex) -> Int {
		let row = index.row 
		let col = index.col
		var matchSize = 1
        let piece = getPiece(index: index)
		var matched = true
		var i = 1
		//Check left
		while(col-i >= 0 && matched) {
            if(piece.isMatching(other: getPiece(index: (row, col-i)))) {
				matchSize += 1
			} else {
				matched = false
			}
			i += 1
		}
		
		//Check below 
		i = 1
		matched = true
		while(col+i < columns && matched) {
            if(piece.isMatching(other: getPiece(index: (row, col+i)))) {
				matchSize += 1
			} else {
				matched = false
			}
			i += 1
		}
			
		return (matchSize >= 3) ? matchSize : 0
	}
	
}	
