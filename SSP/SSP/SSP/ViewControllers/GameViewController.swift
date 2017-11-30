//
//  GameViewController.swift
//  Switch
//
//  Created by Maurice Baldain on 11/6/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    @IBOutlet weak var titl: UIImageView!
    var character: CharacterModel! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public func setCharacterForThisView(character: CharacterModel) {
        self.character = character
        print("Game started with character as \(character.getName())")
    }
}




//        titl.loadGif(name: "sun_title")
//        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
//        // including entities and graphs.
//        let game = GameModel(start: <#T##Int#>)
//        game.printBoard()
//        game.advanceLevel()
//        for i in 0 ..< 5 {
//            print(game.makeMove(move: ((4,i), direction.down)))
//            game.printBoard()
//        }
//        if let scene = GKScene(fileNamed: "GameScene") {
//
//            // Get the SKScene from the loaded GKScene
//            if let sceneNode = scene.rootNode as! GameScene? {
//
//                // Copy gameplay related content over to the scene
//                sceneNode.entities = scene.entities
//                sceneNode.graphs = scene.graphs
//
//                // Set the scale mode to scale to fit the window
//                sceneNode.scaleMode = .aspectFill
//
//                // Present the scene
//                if let view = self.view as! SKView? {
//                    view.presentScene(sceneNode)
//
//                    view.ignoresSiblingOrder = true
//
//                    view.showsFPS = true
//                    view.showsNodeCount = true
//                    view.backgroundColor = UIColor.white
//                }
//            }
//        }
//    }









//You
