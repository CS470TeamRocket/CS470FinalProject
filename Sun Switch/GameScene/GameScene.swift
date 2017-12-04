//
//  GameScene.swift
//  Switch
//
//  Created by Maurice Baldain on 11/6/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation


class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var sprites = [[SKSpriteNode]]()
    var centers = [[CGPoint]]()
    var TempRowS = [SKSpriteNode]()
    var fakeRowL = [SKSpriteNode]()
    var fakeRowR = [SKSpriteNode]()
    var lastSet = Set<UITouch>()
    var lastEvent = UIEvent()
    var oldRow: RowModel!
    var oldRowS = [SKSpriteNode]()
    var graphs = [String : GKGraph]()
    //var board = [[PieceModel]]()
    var TempRow = [PieceModel]()
    var arrows = [[AModel]]()
    var oldArrows = [[AModel]]()
    var points: [String] = ["3000", "4000", "5000"]
    
    
    let helperSprite = SKSpriteNode(imageNamed:"moon")
    var curSprite: (SKSpriteNode, CGPoint, Int, Int)!
    var firstTouch: CGPoint!
    var curRow: Int!
    var lastIdx: (Int, Int)!
    var lastDirection: direction!
    var otherSprite: (SKSpriteNode, CGPoint, Int, Int)!
    var curArrow: AModel!
    var holding: Bool = false
    var started: Bool = false
    var canMove: Bool = false
    var sun1: PModel!
    var sun2: PModel!
    var sun3: PModel!
    var abilityButton: PModel!
    var quitButton: UIButton!
    var game: GameModel!
    var dir: String = ""
    var bottom = 0
    var maxRows: Int!
    var maxCols: Int!
    var audio: AVAudioPlayer?

    override func sceneDidLoad() {
        super.sceneDidLoad()
        //let rotateAction = SKAction.rotate(byAngle: CGFloat(M_PI * 2.0) , duration: 5)
        //helperSprite.run(SKAction.repeatForever(rotateAction))
        game = GameModel(start: 1, view: self)
        UserDataHolder.shared.currentGameModel = game
        self.backgroundColor = UIColor.white
    }

    func destroySelf() {
        print("Destroying self!")
        UserDataHolder.shared.currentGameModel = nil
        game.gameOver()
        game = nil
        sprites.removeAll()
        entities.removeAll()
       // board.removeAll()
        self.removeAllActions()
        self.removeAllChildren()
    }

    func makeBoard(board: [RowModel]) {
        for r in 0..<board.count {
            TempRow = []
            TempRowS = []
            var TempRowC: [CGPoint] = []
            for c in 0..<board[r].length() {
                let piece = board[r].getPiece(col: c)
                TempRow.append(piece)
                var sprite: SKSpriteNode
                let rows = board.count
                let columns = board[r].length()
                let x = (c - columns/2) * Int(helperSprite.size.width + 4)
                let arc = 0//(x * x) / 500
                let y = (r - rows/2) * Int(helperSprite.size.width + 10) * -1 - arc
                let center = CGPoint(x: x, y: y)
                TempRowC.append(center)
                let name = getImageName(piece: piece)
                sprite = SKSpriteNode(imageNamed: name)
                //let rotateAction = SKAction.rotate(byAngle: CGFloat(M_PI * 2.0) , duration: 5)
                //sprite.run(SKAction.repeatForever(rotateAction))
                sprite.position = center
                sprite.name = name
                self.addChild(sprite)
                TempRowS.append(sprite)
            }
            //self.board.append(TempRow)
            self.sprites.append(TempRowS)
            self.centers.append(TempRowC)
            TempRow = []
            TempRowS = []
            TempRowC = []
        }
        maxRows = board.count
        maxCols = board[0].length()
        createOtherSprites()
        bottom = sprites.count - 1
        started = true
        canMove = true
    }
    
    func getImageName(piece: PieceModel) -> String {
        if piece.getTextIcon() == "M" {
            return "moon"
        }
        else if piece.getTextIcon() == "P" {
            return "planet"
        }
        else if piece.getTextIcon() == "A" {
            return "alien"
        }
        else if piece.getTextIcon() == "S" {
            return "satellite"
        }
        else if piece.getTextIcon() == "R" {
            return "rocket"
        }
        else if piece.getTextIcon() == "C" {
            return "comet"
        }

        return ""
    }
    
    func createOtherSprites() {
        let tSize = Int(helperSprite.size.width)
        var count = 0
        let columns = sprites[0].count
        for r in sprites {
            // Arrows
            let x1 = (0 - 1 - (columns / 2)) * (tSize) - Int(helperSprite.size.width/4)
            let y1 = Int(r[0].position.y) - Int(helperSprite.size.width/2)
            let oC1 = CGPoint(x: x1 , y: y1)
            let arrow1 = AModel(row: count, originalCenter: oC1, sprite: SKSpriteNode(texture: sprites[count][maxCols-1].texture))
            let x2 = (columns - (columns / 2)) * (tSize) + Int(helperSprite.size.width/4)
            let y2 = Int(r[columns - 1].position.y) - Int(helperSprite.size.width/2)
            let oC2 = CGPoint(x: x2 , y: y2)
            let arrow2 = AModel(row: count, originalCenter: oC2, sprite: SKSpriteNode(texture: sprites[count][0].texture))
            //let group = SKAction.group([SKAction.rotate(byAngle: CGFloat(M_PI * 2.0) , duration: 5), SKAction.sequence([SKAction.fadeOut(withDuration: 1), SKAction.fadeIn(withDuration: 0.5)])])
            self.addChild(arrow1.sprite)
            arrow1.sprite.position = arrow1.originalCenter
            //arrow1.sprite.run(SKAction.repeatForever(group))
            self.addChild(arrow2.sprite)
            arrow2.sprite.position = arrow2.originalCenter
            //arrow2.sprite.run(SKAction.repeatForever(group))
            arrows.append([arrow1, arrow2])
            count += 1
        }
        // Suns
        sun1 = PModel(row: 0, column: 0, imgIdx: 0, originalCenter: CGPoint(x: (-frame.width / 4) + CGFloat(40), y: (-frame.height / 2) + CGFloat(40)), sprite: SKSpriteNode(imageNamed: "sun"))
        self.addChild(sun1.sprite)
        sun1.sprite.position = sun1.originalCenter
        sun2 = PModel(row: 0, column: 0, imgIdx: 0, originalCenter: CGPoint(x: (frame.width / 4) - CGFloat(40), y: (-frame.height / 2) + CGFloat(40)), sprite: SKSpriteNode(imageNamed: "sun"))
        self.addChild(sun2.sprite)
        sun2.sprite.position = sun2.originalCenter
        sun3 = PModel(row: 00, column: 0, imgIdx: 0, originalCenter: CGPoint(x: 0, y: (-frame.height / 2) + CGFloat(40)), sprite: SKSpriteNode(imageNamed: "sun"))
        self.addChild(sun3.sprite)
        sun3.sprite.position = sun3.originalCenter
        // AbilityButton
        abilityButton = PModel(row: 0, column: 0, imgIdx: 0, originalCenter: CGPoint(x: (-frame.width/2) + CGFloat(40), y: (-frame.height/2) + CGFloat(40)), sprite: SKSpriteNode(imageNamed:"helmet"))
        self.addChild(abilityButton.sprite)
        abilityButton.sprite.position = abilityButton.originalCenter
        //ResignButton
        //resignButton = PModel(row: 0, column: 0, imgIdx: 0, originalCenter: CGPoint(x: (frame.width/2) - CGFloat(40), y: (-frame.height/2) + CGFloat(40)), sprite: SKSpriteNode(imageNamed:"physics"))
        //self.addChild(resignButton.sprite)
        //resignButton.sprite.position = resignButton.originalCenter
    }
 
    func dropFromTop(Index: BoardIndex) -> SKAction {
        
        //_ = DispatchTime.now() + .milliseconds(500000000)
        let r = Index.row
        let c = Index.col
        let center = centers[r][c]
        let yo = Int(center.y) + Int(helperSprite.size.height) * 2
        let startCenter = CGPoint(x: Int(center.x) , y: yo)
        var sprite: SKSpriteNode
        let name = getImageName(piece: game.board.getPiece(index: Index))
        sprite = SKSpriteNode(imageNamed: name)
        self.addChild(sprite)
        sprite.position = startCenter
        sprite.zRotation = helperSprite.zRotation
        let group = SKAction.group([SKAction.move(to: center, duration: 0.4), SKAction.fadeAlpha(to: 1, duration: 0.4)])
        //let rotateAction = SKAction.rotate(byAngle: CGFloat(M_PI * 2.0) , duration: 5)
        //sprite.run(SKAction.repeatForever(rotateAction))
        let act = SKAction.run {
            sprite.run(group)
            self.run(SKAction.wait(forDuration: 1))
        }
        sprite.name = name
        sprites[r][c] = sprite
        //board[r][c] = game.board.getPiece(index: BoardIndex(row: r, col: c))
        return act
    }
    
    func printNames() {
        for i in sprites {
            print("[", terminator:" ")
            for j in i {
                let index = j.name!.index(j.name!.startIndex, offsetBy: 2)
                print(j.name!.substring(to: index), terminator: " ")
            }
            print("]")
        }
        print("")
    }
    
    func drop(from: BoardIndex, to: BoardIndex) -> SKAction {
        //_ = DispatchTime.now() + .milliseconds(500000000)
        //self.run(SKAction.wait(forDuration: 5))
        let center = centers[to.row][to.col]
        let startCenter = centers[from.row][from.col]
        var sprite: SKSpriteNode
        sprite = sprites[from.row][from.col]
        //sprite.alpha = 0
        sprite.position = startCenter
        let group = SKAction.group([SKAction.move(to: center, duration: 0.4), SKAction.fadeAlpha(to: 1, duration: 0.4)])
        //let rotateAction = SKAction.rotate(byAngle: CGFloat(M_PI * 2.0) , duration: 5)
        //sprite.run(SKAction.repeatForever(rotateAction))
        let act = SKAction.run {
            sprite.run(group)
            self.run(SKAction.wait(forDuration: 1))
        }
        sprites[to.row][to.col] = sprite
        //board[to.row][to.col] = game.board.getPiece(index: to)
        return act
    }
    
    func moveRow(location: CGPoint) {
        // For moving row when arrow has been pressed
        if curArrow != nil, curRow < sprites.count {
            let tDis = location.x - curArrow.sprite.position.x
            for s in sprites[curRow] {
                s.position.x += tDis
                let tSize = Int(helperSprite.size.width)
                let y = (curRow - (maxRows / 2)) * (tSize + 10) * -1
                let arc = 0//Int(s.position.x * s.position.x) / 500
                s.position.y = CGFloat(y - arc)
            }
            for s in fakeRowL {
                s.position.x += tDis
                let tSize = Int(helperSprite.size.width)
                let y = (curRow - (maxRows / 2)) * (tSize + 10) * -1
                let arc = 0//Int(s.position.x * s.position.x) / 500
                s.position.y = CGFloat(y - arc)
            }
            for s in fakeRowR {
                s.position.x += tDis
                let tSize = Int(helperSprite.size.width)
                let y = (curRow - (maxRows / 2)) * (tSize + 10) * -1
                let arc = 0//Int(s.position.x * s.position.x) / 500
                s.position.y = CGFloat(y - arc)
            }
            curArrow.sprite.position.x = location.x
        }
    }
    
    func snapBack(sprite: SKSpriteNode, row: Int, col: Int) {
        // Move pieces back to their centers with an action
        let rotateAction = SKAction.rotate(byAngle: CGFloat(M_PI * 2.0) , duration: 0.4)
        let updatePosition = SKAction.run {
            sprite.position = self.centers[row][col]
        }
        let moveAndRotate = SKAction.group([rotateAction, updatePosition])
        sprite.run(moveAndRotate)
    }
    
    func snapBackRow(newSprites: [SKSpriteNode]) {
        // Moves a whole row back to it's original place
        if curRow != nil {
            print("SBR -> \(curRow)")
            for a in arrows[curRow] {
                a.sprite.position = a.originalCenter
            }
            printSpriteRow(row: newSprites)
            sprites[curRow] = newSprites
            for c in 0..<maxCols {
                var s: SKSpriteNode
                //sprites[curRow][c] = newSprites[c]
                s = sprites[curRow][c]
                //let moveAction = SKAction.moveBy(x: 10, y: -15, duration: 0.8)
                let r = curRow!
                let rotateAction = SKAction.rotate(byAngle: CGFloat(M_PI * 2.0) , duration: 0.4)
                let updatePosition = SKAction.run {
                    s.position = self.centers[r][c]
                }
                let moveAndRotate = SKAction.group([rotateAction, updatePosition])
                s.run(moveAndRotate)
            }
        }
    }
    
    func snapRow(point: CGPoint) {
        let distance = point.x - firstTouch.x
        for a in arrows[curRow] {
            a.sprite.position = a.originalCenter
        }
        var newRow: RowModel
        newRow = game.board.getBoard()[curRow]
        var newRowS: [SKSpriteNode] = []
        var tempRow: [PieceModel] = []
        for p in newRow.getPieces() {
            tempRow.append(p)
        }
        let moves = Int(distance) / Int(helperSprite.size.width + 4)
        print("Moves: \(moves)")
        if moves > 0 {
            for i in 0..<maxCols {
                let index = (i + moves) % maxCols
                //let piece = game.board.getPiece(index: BoardIndex(row: curRow, col: index))
                newRow.changePiece(col: i, other: tempRow[i])
                newRowS.append(sprites[curRow][index])
            }
            
        }
        else if moves < 0 {
            for i in 0..<maxCols {
                var index = (i + moves)
                if index < 0 {
                    index = index + maxCols
                }
                //index = index % maxCols
                //let piece = game.board.getPiece(index: BoardIndex(row: curRow, col: index))
                newRow.changePiece(col: i, other: tempRow[i])
                newRowS.append(sprites[curRow][index])
            }
        }
        else {
            newRowS = sprites[curRow]
        }
        game.board.setBoard(row: newRow, index: curRow)
        print("Updating", terminator: " ")
        printSpriteRow(row: sprites[curRow])
        print("To", terminator: " ")
        printSpriteRow(row: newRowS)
        sprites[curRow] = newRowS
        
    }
    
    func printSpriteRow(row: [SKSpriteNode]) {
        for s in row {
            print(s.name!.substring(to: s.name!.index(before: s.name!.index(s.name!.startIndex, offsetBy: 4))), terminator: " ")
        }
        print("")
    }
    
    func hideArrows() {
        for a in arrows[curRow] {
            a.sprite.isHidden = true
        }
    }
    
    func showArrows() {
        for a in arrows {
            for b in a {
                b.sprite.isHidden = false
            }
        }
    }
    
    func updateArrows() {
        for i in 0...bottom {
            arrows[i][0].sprite.texture = sprites[i][sprites[i].count-1].texture
            arrows[i][1].sprite.texture = sprites[i][0].texture
        }
    }
    
    func removeRandFromTop() -> (Int, Int){
        let c = sprites[0].count
        let rand = Int(arc4random()) % c
        var s: SKSpriteNode? = nil
        s = sprites[0][rand]
        s?.run(SKAction.sequence([SKAction.scale(by: 1.5, duration: 0.1), SKAction.scale(by: 0.1, duration: 0.1), SKAction.move(to: CGPoint(x: 0,y :Int(-frame.height)), duration: 0.2), SKAction.fadeOut(withDuration: 0.1)]))
        s?.removeFromParent()
        return (0, rand)
    }
    
    func removeSprite(row: Int, col: Int) -> (SKSpriteNode, SKAction) {
        var s: SKSpriteNode
        s = SKSpriteNode(imageNamed: "moon")
        if row >= 0, row < maxRows, col >= 0, col < maxCols {
            s = sprites[row][col]
            let action = SKAction.run {
                //let scaleUp = SKAction.scale(by: 1.5, duration: 0.2)
                let scaleDown = SKAction.scale(by: 0.1, duration: 0.2)
                //let move = SKAction.move(to: CGPoint(x: 0,y :Int(-self.frame.height)), duration: 0.2)
                let fade = SKAction.fadeOut(withDuration: 0.5)
                //let wait = SKAction.wait(forDuration: 0.3)
                let remove = SKAction.removeFromParent()
                s.run(SKAction.sequence([scaleDown, fade, remove]))
                //print("DONE DID.")
            }
            return (s, action)
        }
        return (s, SKAction.removeFromParent())
    }
    
    func removeBottomRow() {
        // Removes row with action
        //print("Bottom should be:", bottom)
        if bottom >= 0 {
            //game.board.removeRow()
            var count = 0
            for s in sprites[bottom] {
               // print("Deleting sprite at:", bottom, count, s.position)
                s.run(SKAction.sequence([SKAction.scale(by: 1.5, duration: 0.1), SKAction.scale(by: 0.1, duration: 0.1), SKAction.move(to: CGPoint(x: 0,y :Int(-frame.height)), duration: 0.2), SKAction.fadeOut(withDuration: 0.1)]))
                s.removeFromParent()
                count += 1
            }
            oldArrows.insert(arrows[bottom], at: 0)
            for a in arrows[bottom] {
                a.sprite.removeFromParent()
            }
            //board.remove(at: board.count-1)
            sprites.remove(at: bottom)
            //print(board.count, "&", sprites.count)
            print("Changing bottom to:", bottom-1)
            bottom -= 1
        }
    }
    
    func recreateBottomRow(newRow: RowModel) {
        print(bottom, "<", maxRows)
        if bottom < maxRows-1 {
            //game.restoreRow()
            print("Bottom is currently:", bottom)
            for r in 0..<sprites[0].count {
                let piece = newRow.getPiece(col: r)
                TempRow.append(piece)
                var sprite: SKSpriteNode
                let center = centers[bottom+1][r]
                let name = getImageName(piece: piece)
                sprite = SKSpriteNode(imageNamed: name)
                self.addChild(sprite)
                sprite.position = center
                sprite.run(SKAction.sequence([SKAction.scale(by: 0.5, duration: 0.1), SKAction.scale(by: 4, duration: 0.1), SKAction.scale(by: 0.5, duration: 0.1)]))
                //let rotateAction = SKAction.rotate(byAngle: CGFloat(M_PI * 2.0) , duration: 5)
                //sprite.run(SKAction.repeatForever(rotateAction))
                //print("Added sprite at:", bottom + 1, r, sprite.position)
                sprite.name = name
                TempRowS.append(sprite)
            }
            arrows.append(oldArrows[0])
            for a in arrows[bottom+1] {
                addChild(a.sprite)
                a.sprite.run(SKAction.fadeIn(withDuration: 0.1))
            }
            //print(oldArrows.count)
            oldArrows.remove(at: 0)
            //print(oldArrows.count)
           // board.append(TempRow)
            sprites.append(TempRowS)
            TempRow = []
            TempRowS = []
            print("Changing bottom to:", bottom+1)
            bottom += 1
        }
    }

    func snapAllBack() {
        for row in 0..<sprites.count-1 {
            for col in 0..<sprites[row].count-1 {
                if sprites[row][col].texture != nil {
                    sprites[row][col].position = centers[row][col]
                }
            }
        }
        for a in arrows {
            for b in a {
                b.sprite.position = b.originalCenter
            }
        }
    }
    
    func pointPop(row: Int, col: Int) {
        let cp = centers[row][col]
        let rand = Int(arc4random()) % 3
        let sp = SKSpriteNode(imageNamed: points[rand])
        self.addChild(sp)
        sp.setScale(0.5)
        sp.position = cp
        let group = SKAction.group([SKAction.moveBy(x: 0, y: 15, duration: 0.2), SKAction.fadeOut(withDuration: 0.2)])
        let seque = SKAction.sequence([group, SKAction.removeFromParent()])
        sp.run(seque)
    }

    func makeFakeRows(sprites: [SKSpriteNode], row: Int) {
        for c in sprites {
            var arc = 0
            let y = (row - maxRows/2) * Int(helperSprite.size.width + 10) * -1
            //let rotateAction = SKAction.rotate(byAngle: CGFloat(M_PI * 2.0) , duration: 5)
            let distance = helperSprite.size.width * CGFloat(maxCols) + helperSprite.size.width/2
            let rotation = c.zRotation
            var fakeR: SKSpriteNode
            var fakeL: SKSpriteNode
            
            fakeL = SKSpriteNode(texture: c.texture)
            fakeL.position.x = c.position.x - distance
            arc = y// + Int(fakeL.position.x * fakeL.position.x) / 500 * -1
            fakeL.position.y = CGFloat(arc)
            fakeL.zRotation = rotation
            //fakeL.run(SKAction.repeatForever(rotateAction))
            self.addChild(fakeL)
            fakeRowL.append(fakeL)
            
            fakeR = SKSpriteNode(texture: c.texture)
            fakeR.position.x = c.position.x + distance
            arc = y// + Int(fakeR.position.x * fakeR.position.x) / 500 * -1
            fakeR.position.y = CGFloat(arc)
            fakeR.zRotation = rotation
            //fakeR.run(SKAction.repeatForever(rotateAction))
            self.addChild(fakeR)
            fakeRowR.append(fakeR)
        }
    }
    
    func removeFakeRows() {
        for s in fakeRowL {
            s.removeFromParent()
        }
        for s in fakeRowR {
            s.removeFromParent()
        }
        fakeRowL = []
        fakeRowR = []
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Called When the screen is first touched
        // print("TOUCHES BEGAN")
        // Just hide them
        firstTouch = touches.first?.location(in: self)
        lastSet = touches
        lastEvent = event!
        if(!canMove) {
            return
        }
        for touch in touches {
            let location = touch.location(in: self)
            if self.sun1.sprite.contains(location) {
                if bottom > 0 {
                    //removeBottomRow()
                    game.timeUp()
                }
                //print(bottom)
            }
            else if self.sun2.sprite.contains(location) {
                game.restoreRow()
                //print(bottom)
            }
            else if self.sun3.sprite.contains(location) {
                dropTest()
            }
            else if self.abilityButton.sprite.contains(location){
                UserDataHolder.shared.currentCharacter?.ability.doAbility()
            }
                
            //else if self.resignButton.sprite.contains(location){
             //   UserDataHolder.shared.currentGameModel?.gameOver()
            //}

            for a in arrows {
                for b in a {
                    if !holding, b.sprite.contains(location), b.row <= bottom {
                        //print(b)
                        // Get row with clicked arrow
                        curRow = b.row
                        curArrow = b
                        hideArrows()
                        makeFakeRows(sprites: sprites[curRow], row: curRow)
                        moveRow(location: location)
                        oldRow = game.board.getBoard()[curRow]
                        oldRowS = sprites[curRow]
                        holding = true
                    }
                }
            }
            var ro = 0
            for r in sprites {
                var co = 0
                for sp in r {
                    if !holding, sp.contains(location){
                        // Get curSprite and move center to touch location
                        curSprite = (SKSpriteNode.init(imageNamed: "moon"), CGPoint(x: 0, y: 0), 100, 100)
                        curSprite.0 = sp
                        curRow = ro
                        curSprite.1 = centers[ro][co]
                        curSprite.2 = ro
                        curSprite.3 = co
                        let tDisX = location.x - sp.position.x
                        let tDisY = location.y - sp.position.y
                        sp.position.x += tDisX
                        sp.position.y += tDisY
                        holding = true
                    }
                    co += 1
                }
                co = 0
                ro += 1
            }
            ro = 0
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!canMove) {
            snapAllBack()
            return
        }
        for touch in touches {
            let location = touch.location(in: self)
            if curArrow != nil {
                // Move row if Arrow was pressed in touchesBegan
                moveRow(location: location)
            }
            //curSprite.sprite.run(SKAction.scale(by: 1.2, duration: 0.1))
            else if curSprite != nil {
                let bSize = Int(helperSprite.size.width) / 2
                let cDisX = Int(curSprite.0.position.x - curSprite.1.x)
                let cDisY = Int(curSprite.0.position.y - curSprite.1.y)
                let tDisX = Int(location.x - curSprite.0.position.x)
                let tDisY = Int(location.y - curSprite.0.position.y)
                let bDisX = Int(location.x - curSprite.1.x)
                let bDisY = Int(location.y - curSprite.1.y)
                let tooFar = Int(helperSprite.size.width * 2)
                var closer = false
                if (bDisX < cDisX) || (bDisY < cDisY) {
                    closer = true
                }
                if ((abs(cDisY) > tooFar) || (abs(cDisX) > tooFar)) && (closer != true) {
                    closer = false
                    //Do Nothing if location is too far from center
                }
                else {
                    curSprite.0.position.y += CGFloat(tDisY)
                    curSprite.0.position.x += CGFloat(tDisX)
                    // Move Sprite
                    if (abs(cDisX) < bSize) && (abs(cDisY) < bSize) {
                        // Snap swapping pies back if current sprit moves back close to its center
                        if otherSprite != nil {
                            snapBack(sprite: otherSprite.0, row: otherSprite.2, col: otherSprite.3)
                            otherSprite = nil
                        }
                        dir = ""
                    }
                    // dir will be Zach's enemerated type
                    else if (cDisY > bSize) && (dir == "" || dir == "up") {
                        //print("UP")
                        dir = "up"
                        if curSprite.2 != 0 {
                            lastDirection = direction.up
                            //otherSprite = game.gameBoard.board[curSprite.row + 1][curSprite.column]
                            if otherSprite == nil {
                                //print("nil")
                                otherSprite = (SKSpriteNode.init(imageNamed: "moon"), CGPoint(x: 0, y: 0), 100, 100)
                                let r = curSprite.2 - 1
                                let c = curSprite.3
                                otherSprite.0 = sprites[r][c]
                                otherSprite.1 = centers[r][c]
                                otherSprite.2 = r
                                otherSprite.3 = c
                                otherSprite.0.position.y -= CGFloat(cDisY)
                                otherSprite.0.position.x -= CGFloat(cDisX)
                            }
                            else {
                                otherSprite.0.position.y -= CGFloat(tDisY)
                                otherSprite.0.position.x -= CGFloat(tDisX)
                            }
                        }
                    }
                    else if (cDisY < -bSize) && (dir == "" || dir == "down") {
                        //print("DOWN")
                        dir = "down"
                        if curSprite.2 != maxRows - 1, curSprite.2 != bottom { //, game.gameBoard.board[curSprite.row - 1][curSprite.column].sprite != nil {
                            //otherSprite = game.gameBoard.board[curSprite.row - 1][curSprite.column]
                            lastDirection = direction.down
                            if otherSprite == nil {
                                //print("nil")
                                otherSprite = (SKSpriteNode.init(imageNamed: "moon"), CGPoint(x: 0, y: 0), 100, 100)
                                let r = curSprite.2 + 1
                                let c = curSprite.3
                                otherSprite.0 = sprites[r][c]
                                otherSprite.1 = centers[r][c]
                                otherSprite.2 = r
                                otherSprite.3 = c
                                otherSprite.0.position.y -= CGFloat(cDisY)
                                otherSprite.0.position.x -= CGFloat(cDisX)
                            }
                            else {
                                otherSprite.0.position.y -= CGFloat(tDisY)
                                otherSprite.0.position.x -= CGFloat(tDisX)
                            }
                        }
                    }
                    else if (cDisX > bSize) && (dir == "" || dir == "right") {
                        //print("RIGHT")
                        dir = "right"
                        if curSprite.3 != maxCols + 1  {
                            lastDirection = direction.right
                            //otherSprite = game.gameBoard.board[curSprite.row][curSprite.column + 1]
                            if otherSprite == nil {
                                //print("nil")
                                otherSprite = (SKSpriteNode.init(imageNamed: "moon"), CGPoint(x: 0, y: 0), 100, 100)
                                let r = curSprite.2
                                let c = curSprite.3 + 1
                                otherSprite.0 = sprites[r][c]
                                otherSprite.1 = centers[r][c]
                                otherSprite.2 = r
                                otherSprite.3 = c

                                otherSprite.0.position.y -= CGFloat(cDisY)
                                otherSprite.0.position.x -= CGFloat(cDisX)
                            }
                            else {
                                otherSprite.0.position.y -= CGFloat(tDisY)
                                otherSprite.0.position.x -= CGFloat(tDisX)
                            }
                        }
                    }
                    else if (cDisX < -bSize) && (dir == "" || dir == "left") {
                        //print("LEFT")
                        dir = "left"
                        if curSprite.3 != 0 {
                            lastDirection = direction.left
                            //otherSprite = game.gameBoard.board[curSprite.row][curSprite.column - 1]
                            if otherSprite == nil {
                                //print("nil")
                                otherSprite = (SKSpriteNode.init(imageNamed: "moon"), CGPoint(x: 0, y: 0), 100, 100)
                                let r = curSprite.2
                                let c = curSprite.3 - 1
                                otherSprite.0 = sprites[r][c]
                                otherSprite.1 = centers[r][c]
                                otherSprite.2 = r
                                otherSprite.3 = c

                                otherSprite.0.position.y -= CGFloat(cDisY)
                                otherSprite.0.position.x -= CGFloat(cDisX)
                            }
                            else {
                                otherSprite.0.position.y -= CGFloat(tDisY)
                                otherSprite.0.position.x -= CGFloat(tDisX)
                            }
                        }
                    }
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!canMove) {
            snapAllBack()
            return
        }
        //print("TOUCHES ENDED")
        showArrows()
        for touch in touches {
            _ = touch
            if curArrow != nil {
                print("CURARROW -> \(curRow)")
                removeFakeRows()
                snapRow(point: touches.first!.location(in: self))
                var moves: [Move] = []
                for i in 0..<maxCols-1 {
                    moves.append(Move(BoardIndex(row: curRow, col: i), dir: direction.right))
                }
                let move = game.makeRowMove(moves: moves)
                if move {
                    snapBackRow(newSprites: sprites[curRow])
                }
                else {
                    snapBackRow(newSprites: oldRowS)
                    game.board.setBoard(row: oldRow, index: curRow)
                }
                //snapBackRow()
            }
            else if otherSprite != nil, lastDirection != nil {
                swap()
                snapBack(sprite: otherSprite.0, row: otherSprite.2, col: otherSprite.3)
                snapBack(sprite: curSprite.0, row: curSprite.2, col: curSprite.3)
                lastIdx = (curSprite.2, curSprite.3)
                print("MOVE")
                let move = game.makeMove(move: Move(BoardIndex(lastIdx), dir: lastDirection))
                if !move {
                    swap()
                }
            }
            else if curSprite != nil {
                snapBack(sprite: curSprite.0, row: curSprite.2, col: curSprite.3)
                lastIdx = (curSprite.2, curSprite.3)
            }
            holding = false
            //if lastDirection != nil, lastIdx != nil, otherSprite != nil {
            //    print("MOVE")
            //    let move = game.makeMove(move: Move(BoardIndex(lastIdx), dir: lastDirection))
            //    if !move {
            //        swap()
            //    }
            //}
        }
        snapAllBack()
        fakeRowL = []
        fakeRowR = []
        curSprite = nil
        otherSprite = nil
        curArrow = nil
        lastDirection = nil
        lastIdx = nil
        firstTouch = nil
        curRow = nil
        oldRow = nil
        oldRowS = []
        updateArrows()
        printNames()
    }
    
    func doSequencialActions(actions: [SKAction], index: Int) {
        if actions.count == 1 {
            self.run(actions[0])
        }
        else if index < actions.count - 1 {
            self.run(actions[index], completion: {
                self.doSequencialActions(actions: actions, index: index + 1)
            })
        }
    }
    
    func dropTest() {
        //let rand = Int(arc4random()) % maxCols
        let idx = removeRandFromTop()
        pointPop(row: idx.0, col: idx.1)
        //dropFromTop(row: idx.0, col: idx.1)
    }
    
    func swap() {
        //let r = curSprite.2
        //let c = curSprite.3
        //let r2 = otherSprite.2
        //let c2 = otherSprite.3
        let tempSpriteTex = curSprite.0.texture
        //let tempPiece = game.board.getPiece(index: (r,c))
        //let tempType = getImageName(piece: tempPiece)
        
        curSprite.0.texture = otherSprite.0.texture
        //self.board[r][c] = game.board.getPiece(index: (r2,c2))
        //curSprite.imgIdx = otherSprite.imgIdx
        otherSprite.0.texture = tempSpriteTex
        //self.board[r2][c2] = tempPiece
        //otherSprite.imgIdx = tempImgIdx
        //game.board.getPiece(index: (r,c)).swap(new: game.board.getPiece(index: (r2,c2)))
    }
    
    func swapRow(newRow: RowModel) {
        
    }
    
    func updateScore(score: Int) {
        
    }
    
    func enableMove() {
        canMove = true
    }
    
    func disableMove() {
        canMove = false
        curSprite = nil
        otherSprite = nil
        curArrow = nil
        lastDirection = nil
        lastIdx = nil
        holding = false
    }

    override func update(_ currentTime: TimeInterval) {
        
    }
}





















//
