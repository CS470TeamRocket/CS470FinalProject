//
//  RowModel.swift
//  Sun Switch
//
//  Created by Maurice Baldain on 11/7/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation

class RowModel :NSObject {
    private var pieces : [PieceModel] = [PieceModel]()
    private var index : Int = 0
    private var isLast : Bool = false
    private let columns : Int
    init(row: Int, col: Int, last: Bool) {
        index = row
        columns = col
        isLast = last
    }
    
    func populate(pieceList: [PieceModel]) {
        for i in 0 ..< columns {
            let piece : PieceModel = 
            pieces.append(PieceModel())
        }
    }
}
