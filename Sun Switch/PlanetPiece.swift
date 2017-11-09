//
//  PlanetPiece.swift
//  Sun Switch
//
//  Created by student on 11/8/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class PlanetPiece: PieceModel {
    let planetType: pieceType = pieceType.Planet
    
    required init( /*rowNum: Int, colNum: Int */) {
        super.init(type: planetType)
    }

}
