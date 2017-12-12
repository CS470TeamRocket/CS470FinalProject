//
//  RowModel.swift
//  Sun Switch
//
//  Created by Zachary Brester on 11/7/17.
//  Copyright © 2017 student. All rights reserved.
//
import Foundation

//RowModel:
//This class represents one row of the board. It contains an array of PieceModels, the members of this row.
//Within are a few useful functions involved in the logic of the game, but nothing particularly noteworthy.
//Most logic is handled within BoardModel or GameModel.
class RowModel :NSObject {
    private var pieces : [PieceModel] = [PieceModel]()
    private var index : Int = 0 //The row number represented by this row.
    private var isLast : Bool = false //A Boolean which checks if this row is the last row. Used in BoardModel.
    private let columns : Int   //The number of columns, and therefore the number of pieces in this Row.
    init(row: Int, col: Int, last: Bool) {
        index = row
        columns = col
        isLast = last
    }
    
    func setLast(val : Bool) {
        isLast = val
    }
    
    func addPiece(piece: PieceModel) {
        pieces.append(piece)
    }
    
    func getPiece(col: Int) ->PieceModel {
        return pieces[col]
    }
    
    //printRow()
    //A debugging function, prints the  text representation of the row of characters.
    //Input and Output: None
    //On Finish: A text representation of the row has been printed to the console.
    func printRow() {
        var output : String = "[ "
        for i in 0 ..< columns {
            output += "\(pieces[i].getTextIcon()) "//Fetches the text icon for each piece.
        }
        output += "]"
        print(output)
    }
    
    //rotate(dir: direction, amount: Int)
    //Rotates the row in the given direction for an amount dictated.
    //Input: dir, a direction enumerated type, representing left or right to rotate.
    //amount: The amount to rotate, must be positive.
    //Output: NOne
    //On Finish: The row has been rotated as requested.
    func rotate(dir: direction, amount: Int){
        for _ in 0 ..< amount {
            if(dir == direction.left) {
                pieces.append(pieces.removeFirst()) //Repeatedly shifts one at a time. Since the list will
                                                    //not be larger than about 10, I opted for readability.
                //print("First on end")
            }
            else {
                pieces.insert(pieces.removeLast(), at: 0)
                //print("Last on start")
            }
        }
    }
    //changePiece(col: Int, other: PieceModel
    //Changes the piece in the given position with the given PieceModel
    //Input: col, represents the column (position) of the piece to change.
    //other: represents the piece to swap with.
    //Output: None
    //On Finish: The piece at position col has been swapped with other.
    func changePiece(col: Int, other: PieceModel) {
        pieces[col].swap(new: other)
    }
    
    func length() -> Int {
        return columns
    }
    
    func getPieces() -> [PieceModel] {
        return pieces
    }
}
 
 
 
