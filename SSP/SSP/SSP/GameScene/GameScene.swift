//
//  GameScene.swift
//  Switch
//
//  Created by Maurice Baldain on 11/6/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var sprites = [[SKSpriteNode]]()
    var graphs = [String : GKGraph]()
    var arrows = [[ArrowModel]]()
    
    let sprite = SKSpriteNode(imageNamed:"icons8-moon-phase")
    // Just a sprite used for calculatin size sometimes
    var curSprite: PieceModel!
    var otherSprite: PieceModel!
    // SKSpritenodes to hold pressed and one to swap
    var curArrow: ArrowModel!
    // SKSpritenode if arrow is pressed
    var sun1: PieceModel!
    var sun2: PieceModel!
    // 1)Destroy row 2)Make row
    var game = GameModel()
    var dir: String = ""
    // will be Zach's gameModel and dir will be Z's enumerated type
    var bottom = 0
    //holds which row is at the bottom
    
    
    override func didMove(to: SKView) {
        /* Setup your scene here */
        game.startGame(frame: self.frame)
        createSprites()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Called When the screen is first touched
        // print("TOUCHES BEGAN")
        hideArrows()
        // Just hide them
        for touch in touches {
            let location = touch.location(in: self)
            if self.sun1.sprite.contains(location) {
                // Button(SKSpriteNode to delete row
                if bottom < game.gameBoard.rows {
                    removeBottomRow()
                }
                print(bottom)
            }
            if self.sun2.sprite.contains(location) {
                // Button(SKSpriteNode to create row
                if bottom > 0 {
                    recreateBottomRow()
                }
                print(bottom)
            }
            for a in arrows {
                for b in a {
                    if b.sprite.contains(location) {
                        // Get row with clicked arrow
                        print(b.row)
                        curArrow = b
                        moveRow(location: location)
                    }
                }
            }
            for r in game.gameBoard.board {
                for sp in r {
                    if sp.sprite.contains(location){
                        // Get curSprite and move center to touch location
                        curSprite = sp
                        let tDisX = location.x - sp.sprite.position.x
                        let tDisY = location.y - sp.sprite.position.y
                        sp.sprite.position.x += tDisX
                        sp.sprite.position.y += tDisY
                        //curSprite.sprite.run(SKAction.scale(by: 1.2, duration: 0.1))
                        //let y = (curSprite.row - (game.gameBoard.rows / 2)) * (tSize + 10)
                        //let arc = abs(Int(s.sprite.position.x) ^ 2) / 4
                        //s.sprite.position.y = CGFloat(y - arc)
                        // Uncomment to add arc
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if curArrow != nil {
                // Move row if Arrow was pressed in touchesBegan
                moveRow(location: location)
            }
            //curSprite.sprite.run(SKAction.scale(by: 1.2, duration: 0.1))
            else if curSprite != nil {
                let bSize = Int(sprite.size.width) / 2
                let cDisX = Int(curSprite.sprite.position.x - curSprite.originalCenter.x)
                let cDisY = Int(curSprite.sprite.position.y - curSprite.originalCenter.y)
                let tDisX = Int(location.x - curSprite.sprite.position.x)
                let tDisY = Int(location.y - curSprite.sprite.position.y)
                let bDisX = Int(location.x - curSprite.originalCenter.x)
                let bDisY = Int(location.y - curSprite.originalCenter.y)
                let tooFar = Int(sprite.size.width * 2)
                var closer = false
                if (bDisX < cDisX) || (bDisY < cDisY) {
                    closer = true
                }
                if ((abs(cDisY) > tooFar) || (abs(cDisX) > tooFar)) && (closer != true) {
                    closer = false
                    //Do Nothing if location is too far from center
                }
                else {
                    curSprite.sprite.position.y += CGFloat(tDisY)
                    curSprite.sprite.position.x += CGFloat(tDisX)
                    // Move Sprite
                    if (abs(cDisX) < bSize) && (abs(cDisY) < bSize) {
                        // Snap swapping pies back if current sprit moves back close to its center
                        if otherSprite != nil {
                            snapBack(piece: otherSprite)
                            otherSprite = nil
                        }
                        dir = ""
                    }
                    // dir will be Zach's enemerated type
                    else if (cDisY > bSize) && (dir == "" || dir == "up") {
                        //print("UP")
                        dir = "up"
                        if curSprite.row != game.gameBoard.rows - 1 {
                            //otherSprite = game.gameBoard.board[curSprite.row + 1][curSprite.column]
                            if otherSprite == nil {
                                //print("nil")
                                otherSprite = game.gameBoard.board[curSprite.row + 1][curSprite.column]
                                otherSprite.sprite.position.y -= CGFloat(cDisY)
                                otherSprite.sprite.position.x -= CGFloat(cDisX)
                            }
                            else {                            otherSprite.sprite.position.y -= CGFloat(tDisY)
                                otherSprite.sprite.position.x -= CGFloat(tDisX)
                            }
                        }
                    }
                    else if (cDisY < -bSize) && (dir == "" || dir == "down") {
                        //print("DOWN")
                        dir = "down"
                        if curSprite.row != 0, game.gameBoard.board[curSprite.row - 1][curSprite.column] != nil {
                            //otherSprite = game.gameBoard.board[curSprite.row - 1][curSprite.column]
                            if otherSprite == nil {
                                //print("nil")
                                otherSprite = game.gameBoard.board[curSprite.row - 1][curSprite.column]
                                otherSprite.sprite.position.y -= CGFloat(cDisY)
                                otherSprite.sprite.position.x -= CGFloat(cDisX)
                            }
                            else {
                                otherSprite.sprite.position.y -= CGFloat(tDisY)
                                otherSprite.sprite.position.x -= CGFloat(tDisX)
                            }
                        }
                    }
                    else if (cDisX > bSize) && (dir == "" || dir == "right") {
                        //print("RIGHT")
                        dir = "right"
                        if curSprite.column != game.gameBoard.columns - 1  {
                            //otherSprite = game.gameBoard.board[curSprite.row][curSprite.column + 1]
                            if otherSprite == nil {
                                //print("nil")
                                otherSprite = game.gameBoard.board[curSprite.row][curSprite.column + 1]
                                otherSprite.sprite.position.y -= CGFloat(cDisY)
                                otherSprite.sprite.position.x -= CGFloat(cDisX)
                            }
                            else {
                                otherSprite.sprite.position.y -= CGFloat(tDisY)
                                otherSprite.sprite.position.x -= CGFloat(tDisX)
                            }
                        }
                    }
                    else if (cDisX < -bSize) && (dir == "" || dir == "left") {
                        //print("LEFT")
                        dir = "left"
                        if curSprite.column != 0 {
                            //otherSprite = game.gameBoard.board[curSprite.row][curSprite.column - 1]
                            if otherSprite == nil {
                                //print("nil")
                                otherSprite = game.gameBoard.board[curSprite.row][curSprite.column - 1]
                                otherSprite.sprite.position.y -= CGFloat(cDisY)
                                otherSprite.sprite.position.x -= CGFloat(cDisX)
                            }
                            else {
                                otherSprite.sprite.position.y -= CGFloat(tDisY)
                                otherSprite.sprite.position.x -= CGFloat(tDisX)
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("TOUCHES ENDED")
        // Show arrows again, snap back pieces, and set temps to nil
        showArrows()
        for touch in touches {
            //let location = touch.location(in: self)
            if curArrow != nil {
                snapBackRow()
            }
            if curSprite != nil {
                snapBack(piece: curSprite)
            }
            if otherSprite != nil {
                snapBack(piece: otherSprite)
            }
            
            curSprite = nil
            otherSprite = nil
            curArrow = nil
        }
    }
    
    
    
    func createSprites() {
        // Place and position all sprites
        for r in game.gameBoard.board {
            for c in r {
                self.addChild(c.sprite)
                c.sprite.position = c.originalCenter
                let rotateAction = SKAction.rotate(byAngle: CGFloat(M_PI * 2.0) , duration: 5)
                c.sprite.run(SKAction.repeatForever(rotateAction))
                // SKActions are used to animate SKSpritenodes
            }
            let tSize = Int(sprite.size.width)
            let x1 = (0 - 1 - (game.gameBoard.columns / 2)) * (tSize)
            let y1 = Int(r[0].sprite.position.y)
            let oC1 = CGPoint(x: x1 , y: y1)
            // Arrows
            let arrow1 = ArrowModel(row: r[0].row, originalCenter: oC1, sprite: SKSpriteNode(imageNamed: "forward"))
            let x2 = (game.gameBoard.columns - (game.gameBoard.columns / 2)) * (tSize)
            let y2 = Int(r[r.count - 1].sprite.position.y)
            let oC2 = CGPoint(x: x2 , y: y2)
            let arrow2 = ArrowModel(row: r[0].row, originalCenter: oC2, sprite: SKSpriteNode(imageNamed: "back"))
            self.addChild(arrow1.sprite)
            arrow1.sprite.position = arrow1.originalCenter
            arrow1.sprite.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeOut(withDuration: 1), SKAction.fadeIn(withDuration: 1)])))
            self.addChild(arrow2.sprite)
            arrow2.sprite.position = arrow2.originalCenter
            arrow2.sprite.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeOut(withDuration: 1), SKAction.fadeIn(withDuration: 1)])))
            arrows.append([arrow1, arrow2])
            // Suns
            sun1 = PieceModel(row: r[0].row, column: 0, imgIdx: 0, originalCenter: CGPoint(x: (-frame.width / 2) + CGFloat(40), y: (-frame.height / 2) + CGFloat(40)), sprite: SKSpriteNode(imageNamed: "sun"))
            self.addChild(sun1.sprite)
            sun1.sprite.position = sun1.originalCenter
            sun2 = PieceModel(row: r[0].row, column: 0, imgIdx: 0, originalCenter: CGPoint(x: (frame.width / 2) - CGFloat(40), y: (-frame.height / 2) + CGFloat(40)), sprite: SKSpriteNode(imageNamed: "sun"))
            self.addChild(sun2.sprite)
            sun2.sprite.position = sun2.originalCenter
        }
        
    }
    func moveRow(location: CGPoint) {
        // For moving row when arrow has been pressed
        if curArrow != nil{
            let tDis = location.x - curArrow.sprite.position.x
            for s in game.gameBoard.board[curArrow.row] {
                s.sprite.position.x += tDis
                let tSize = Int(sprite.size.width)
                let y = (curArrow.row - (game.gameBoard.rows / 2)) * (tSize + 10)
                let arc = 0//abs(Int(s.sprite.position.x) ^ 2) / 4
                // arc is set to zero
                s.sprite.position.y = CGFloat(y - arc)
            }
            curArrow.sprite.position.x = location.x
        }

    }
    func snapBack(piece: PieceModel) {
        // Move pieces back to their centers with an action
        let rotateAction = SKAction.rotate(byAngle: CGFloat(M_PI * 2.0) , duration: 0.4)
        let updatePosition = SKAction.run {
            piece.sprite.position = piece.originalCenter
        }
        let moveAndRotate = SKAction.group([rotateAction, updatePosition])
        piece.sprite.run(moveAndRotate)
    }
    func snapBackRow() {
        // Moves a whole row back to it's original place
        if curArrow != nil {
            let r = curArrow.row
            for a in arrows[r] {
                a.sprite.position = a.originalCenter
            }

            for s in game.gameBoard.board[r] {
                //let moveAction = SKAction.moveBy(x: 10, y: -15, duration: 0.8)
                let rotateAction = SKAction.rotate(byAngle: CGFloat(M_PI * 2.0) , duration: 0.4)
                let updatePosition = SKAction.run {
                    s.sprite.position = s.originalCenter
                }
                let moveAndRotate = SKAction.group([rotateAction, updatePosition])
                s.sprite.run(moveAndRotate)
            }
        }
    }
    func hideArrows() {
        for a in arrows {
            for b in a {
                b.sprite.isHidden = true
            }
        }
    }
    func showArrows() {
        for a in arrows {
            for b in a {
                b.sprite.isHidden = false
            }
        }
    }
    func removeBottomRow() {
        // Removes row with action
        print("Bottom should be:", bottom)
        for s in game.gameBoard.board[bottom] {
            print("Deleting sprite at:", s.row, s.column, s.sprite.position, s.originalCenter)
            s.sprite.run(SKAction.sequence([SKAction.scale(by: 1.5, duration: 0.1), SKAction.scale(by: 0.1, duration: 0.1), SKAction.move(to: CGPoint(x: 0,y :Int(-frame.height)), duration: 0.2), SKAction.fadeOut(withDuration: 0.1)]))
            s.sprite.removeFromParent()
        }
        bottom += 1
    }
    func recreateBottomRow() {
        // Creates row with action
        let temp = game.gameBoard.generateRow(difficulty: 4, frame: self.frame, r: bottom - 1)
        print("Bottom should be:", bottom)
        for r in temp {
                game.gameBoard.board[bottom - 1][r.column] = r
                let s = game.gameBoard.board[bottom - 1][r.column]
                self.addChild(s.sprite)
                s.sprite.position = s.originalCenter
                s.sprite.run(SKAction.sequence([SKAction.scale(by: 0.5, duration: 0.1), SKAction.scale(by: 4, duration: 0.1), SKAction.scale(by: 0.5, duration: 0.1)]))
                let rotateAction = SKAction.rotate(byAngle: CGFloat(M_PI * 2.0) , duration: 5)
                s.sprite.run(SKAction.repeatForever(rotateAction))
                print("Added sprite at:", s.row, s.column, s.sprite.position, s.originalCenter)
        }
        bottom -= 1
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        //if (self.lastUpdateTime == 0) {
        //    self.lastUpdateTime = currentTime
        //}
        
        // Calculate time since last update
        //let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        //for entity in self.entities {
        //    entity.update(deltaTime: dt)
        //}
        
        //self.lastUpdateTime = currentTime
    }
}
