//
//  PieceModel.swift
//  Switch Personal
//
//  Created by Maurice Baldain on 11/15/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import SpriteKit

struct PieceModel {
    let row: Int
    let column: Int
    let imgIdx: Int
    let originalCenter: CGPoint
    let sprite : SKSpriteNode
}

struct ArrowModel {
    let row: Int
    let originalCenter: CGPoint
    let sprite : SKSpriteNode
}
