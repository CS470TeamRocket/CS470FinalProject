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
    
    let sprite = SKSpriteNode(imageNamed:"Spaceship")
    let curSprite = SKSpriteNode()
    
    
    func createSprites() {
        for r in -5 ..< 8 {
            var temp: [SKSpriteNode] = []
            for i in -5 ..< 6 {
                let sp = SKSpriteNode(imageNamed:"Spaceship")
                sp.xScale = 0.1
                sp.yScale = 0.1
                let newX = (Int(sprite.size.width) / 10 * i) + Int(sprite.size.width) / 20 - 10
                let off = (Int(abs(Int32(i))) * Int(Double(sprite.size.width) / 40.0))
                
                
                let neyY = (Int(sprite.size.width) / 14 + 10) * r - off
                sp.position = CGPoint(x: newX, y: neyY)
                temp.append(sp)
                self.addChild(sp)
            }
            sprites.append(temp)
        }
    }
    
    override func didMove(to: SKView) {
        /* Setup your scene here */
        createSprites()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        print("TOUCHES BEGAN")
        for touch in touches {
            let location = touch.location(in: self)
            for r in sprites {
                for sp in r {
                    if sp.contains(location){
                        let tDis = location.x - sp.position.x
                            for s in r {
                                s.position.x += tDis
                        }
                    }
                }
            }
        }
        
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            for r in sprites {
                for sp in r {
                    if sp.contains(location){
                        let tDis = location.x - sp.position.x
                        for s in r {
                            s.position.x += tDis
                        }
                    }
                }
            }
        }
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
