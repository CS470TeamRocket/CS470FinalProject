//
//  BoardModel.swift
//  Switch Personal
//
//  Created by Maurice Baldain on 11/15/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
// I added this to check something

import  UIKit
import SpriteKit


enum direction {
    case left
    case right
    case up
    case down
<<<<<<< HEAD
=======
    func opposite() ->direction {
        if(self == direction.left) {
            return direction.right
        }
        return direction.left
    }
    
>>>>>>> Zach
}

typealias BoardIndex = (row: Int, col: Int)
typealias Move = (index: BoardIndex, dir: direction)
<<<<<<< HEAD
=======
typealias MoveResult = (success: Bool, clears: [Int])
>>>>>>> Zach

class BoardModel: NSObject {
    private let rows: Int = 9 // Number of starting Rows. The number of columns is determined in the RowModel
    private var currentRows : Int = 9 // Current number of rows. This cannot exceed rows
    private var columns : Int = 7
    private var board : [RowModel] = [RowModel]()
    private var scene : GameScene
    private var diff : Int
    private var validPieces : [pieceType] = [pieceType]()	//The roster of available pieces. This is based
<<<<<<< HEAD
=======
    private var rowMatch = false
>>>>>>> Zach
    //on the current level.
    
    init(difficulty: Int, scene: GameScene) {
        diff = (difficulty <= 0 ) ? 1 : difficulty
        self.scene = scene
        super.init()
        generatePieces()
        generateBoard()
        let matchList = checkAll()
        for i in 0 ..< matchList.count {
            print(matchList[i])
        }
<<<<<<< HEAD
        update()
=======
        _ = update()
>>>>>>> Zach
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
<<<<<<< HEAD
=======
        scene.recreateBottomRow(newRow: row)
>>>>>>> Zach
        //Any other cleanup we might need.
    }
    
    func removeRow() {
        if(currentRows <= 1) {
            print("Error in removal!")
            return
        }
<<<<<<< HEAD
        board.removeLast()
        board.last!.setLast(val: true)
        currentRows -= 1
=======
        scene.disableMove()
        board.removeLast()
        board.last!.setLast(val: true)
        scene.removeBottomRow()
        currentRows -= 1
        scene.enableMove()
>>>>>>> Zach
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
    
<<<<<<< HEAD
=======
    func numColumns() -> Int {
        return columns
    }

>>>>>>> Zach
    func printBoard() {
        for i in 0 ..< currentRows {
            board[i].printRow()
        }
    }
    
<<<<<<< HEAD
    func rotateRow(row: Int, dir: direction )-> Bool{
        if(row < rows) {
            board[row].rotate(dir: dir)
            return true
        }
        else {
            return false
=======
    func rotateRow(row: Int, amount: Int, dir: direction )-> MoveResult {
        if(row < rows) {
            var list = [Int]()
            board[row].rotate(dir: dir, amount: amount)
            if( checkAll().count > 0 ) {
                print("Match detected!")
                list = update()
                return (success: true, clears: list)
            }
            else {
                print("No match!")
                board[row].rotate(dir: dir.opposite(), amount: amount)
                return (success: false, clears: list)
            }
        }
        else {
            return (success: false, clears: [Int]())
>>>>>>> Zach
        }
    }
    
    func checkAll() -> [BoardIndex]{
        var matched = [BoardIndex]()
<<<<<<< HEAD
        for i in 0 ..< rows {
=======
        for i in 0 ..< currentRows {
>>>>>>> Zach
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
    
    func checkMatch(index: BoardIndex)-> Bool {
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
<<<<<<< HEAD
        while(row+i < rows && matched) {
=======
        while(row+i < currentRows && matched) {
>>>>>>> Zach
            if(piece.isMatching(other: getPiece(index: (row+i, col)))) {
                matchSize += 1
            } else {
                matched = false
            }
            i += 1
        }
        
        return (matchSize >= 3) ? matchSize : 0
    }
    
<<<<<<< HEAD
    func makeMove(move: Move) -> Bool {
        if(checkMove(move: move)) {
            print("Hey! That's a match!!")
            _ = swap(move: move)
            update()
            return true
        }
        return false
    }
    
    func update() {
        while(checkAll().count > 0) {
            clearPieces(list: checkAll())
        }
=======
    func makeMove(move: Move) -> MoveResult {
        if(checkMove(move: move)) {
            //print("Hey! That's a match!!")
            _ = swap(move: move)
            let list = update()
            return (success: true, clears: list)
            
        }
        return (success: false, clears: [Int]())
    }
    /*
    func makeMoveForRow(moves: [Move]) -> MoveResult {
        var moveRes: MoveResult
        for m in moves {
            if !rowMatch {
                let move = makeMove(move: m)
                if move.success {
                    //rowMatch = true
                    return move
                }
            }
        }
        return (success: false, clears: [Int]())
    }
    */
    
    func update() ->[Int] {
        var out = [Int]()
        while(checkAll().count > 0) {
            let list = checkAll()
            out.append(list.count)
            clearPieces(list: list)
        }
        return out
>>>>>>> Zach
    }
    
    func checkMove(move: Move) -> Bool {
        let newIndex = swap(move: move)
        let isMatch = checkMatch(index:move.index) || checkMatch(index: newIndex)
        _ = swap(move: move)
        return isMatch
    }
    
<<<<<<< HEAD
    func updateColumn(col: Int) {
        //var actions: [SKAction] = []
        var i = rows-1
        var j = rows-2
=======

    func updateColumn(col: Int) -> [SKAction] {
        var actions: [SKAction] = []
        var i = currentRows-1
        var j = currentRows-2
>>>>>>> Zach
        while(i >= 0) {
            let piece = getPiece(index:(i, col))
            
            if (piece.isEmpty()) {
                var filled : Bool = false
                let to = BoardIndex(row: i, col: col)
                var from = BoardIndex(row: i, col: col)
<<<<<<< HEAD
                
=======
                var group: [SKAction] = []
>>>>>>> Zach
                while(j >= 0 && !filled ) {
                    let replace = getPiece(index: (j, col))
                    if !replace.isEmpty() {
                        piece.swap(new: replace)
                        filled = true
                    }
                    from.row = j
                    if scene.started {
<<<<<<< HEAD
                        print("Drop")
                        scene.drop(from: from, to: to)
                    }
                    j -= 1
                }
=======
                        //print("Drop")

                        //scene.run(scene.drop(from: from, to: to))
                        group.append(scene.drop(from: from, to: to))
                    }
                    j -= 1
                }
                if group.count > 0 {
                    //actions.append(SKAction.group(group))
                    scene.run(SKAction.sequence(group))
                    
                    group = []
                }
>>>>>>> Zach
                
                if (!filled) {
                    piece.genType(valid: validPieces)
                    if scene.started {
<<<<<<< HEAD
                        scene.dropFromTop(Index: BoardIndex(row: i, col: col))
                    }
                }
=======
                        //scene.run(scene.dropFromTop(Index: BoardIndex(row: i, col: col)))
                        group.append(scene.dropFromTop(Index: BoardIndex(row: i, col: col)))
                    }
                }
                if group.count > 0 {
                    //actions.append(SKAction.group(group))
                    scene.run(SKAction.sequence(group))
                    group = []
                }
>>>>>>> Zach
                
            }
            
            i -= 1
            if(j >= i) {
                j = i - 1
            }
            
        }
<<<<<<< HEAD
=======
        //if actions.count > 0 {
        //    scene.doSequencialActions(actions: actions, index: 0)
        //}
        return actions
>>>>>>> Zach
    }
    
    func swap(move: Move) -> BoardIndex {
        var offsetX = move.index.col
        var offsetY = move.index.row
        switch (move.dir) {
        case direction.up:
            if offsetY != 0 {
                offsetY -= 1
            }
        case direction.down:
            if offsetY != rows-1 {
                offsetY += 1
            }
        case direction.left:
            if offsetY != 0 {
                offsetX -= 1
            }
        case direction.right:
            if offsetY != columns-1 {
                offsetX += 1
            }
        }
        getPiece(index: move.index).swap(new: getPiece(index: (offsetY, offsetX)))
        return (offsetY, offsetX)
    }
    
    func clearPieces(list: [BoardIndex]) {
        var actions: [SKAction] = []
        var sprites: [SKSpriteNode] = []
        for idx in list {
            let piece = getPiece(index: idx)
            piece.clear()
            if scene.started {
                let act = scene.removeSprite(row: idx.row, col: idx.col)
                if !sprites.contains(act.0) {
<<<<<<< HEAD
                    actions.append(act.1)
=======
                    scene.run(act.1)
                    //actions.append(act.1)
>>>>>>> Zach
                    sprites.append(act.0)
                }
                scene.pointPop(row: idx.row, col: idx.col)
                //let deadlineTime = DispatchTime.now() + .milliseconds(5000)
            }
        }
<<<<<<< HEAD
        print(actions)
        //scene.run(SKAction.sequence(actions))
        //scene.helperSprite.run(SKAction.wait(forDuration: 10))
        for i in 0..<actions.count {
            let sequence = SKAction.sequence([actions[actions.count-1-i], SKAction.wait(forDuration: 1)])
            scene.run(sequence)
            _ = DispatchTime.now() + .seconds(10)
            scene.run(SKAction.wait(forDuration: 5))
        }
        
=======
        //print(actions)
        //scene.run(SKAction.sequence(actions))
        //scene.helperSprite.run(SKAction.wait(forDuration: 10))
        //for i in 0..<actions.count {
        //    let sequence = SKAction.sequence([actions[actions.count-1-i], SKAction.wait(forDuration: 1)])
        //    scene.run(sequence)
        //    _ = DispatchTime.now() + .seconds(10)
        //    scene.run(SKAction.wait(forDuration: 5))
        //}
>>>>>>> Zach
        
        for i in 0 ..< columns {
            //printBoard()
            //print("")
<<<<<<< HEAD
            updateColumn(col: i)
=======
            actions.append(contentsOf: updateColumn(col: i))
            //if scene.started {
                //sleep(UInt32(1))
            //}
        }
        if actions.count > 0 {
            scene.doSequencialActions(actions: actions, index: 0)
>>>>>>> Zach
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
    
    func getBoard() -> [RowModel] {
        return board
    }
    
<<<<<<< HEAD
=======
    /*
    func setBoard(row: RowModel, index: Int) {
        board[index] = row
    }
    */
    
>>>>>>> Zach
    func getValidPieces() -> [pieceType] {
        return validPieces
    }
}










//
