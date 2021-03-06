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
import AVFoundation

class GameViewController: UIViewController {
    @IBOutlet weak var titl: UIImageView!
    @IBOutlet weak var QuitButton: UIButton!
    @IBOutlet weak var abilityButton: roundedButton!
    var scene : GameScene?
    var extreme : Bool = false
    var classic : Bool = false
    //let AD = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func quit(_ sender: UIButton) {
        scene?.removeAllActions()
        //scene?.game.gameOver()
        //audio!.stop()
        AudioPlayer.shared.stop()
    }
    @IBAction func pauseMusic(_ sender: UIButton) {
        AudioPlayer.shared.pauseMusic()
        /*
        if AD.audio!.isPlaying {
            AD.audio!.pause()
            UserDataHolder.shared.musicMuted = true
        }
        else {
            AD.audio!.play()
            UserDataHolder.shared.musicMuted = false
        }
        */
    }
    
    @IBAction func doAbility(_ sender: roundedButton) {
        scene?.doAbility()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameOver" {
            if let viewController = segue.destination as? GameOverViewController {
                if !(scene?.game.over)! {
                    scene?.removeAllActions()
                    scene?.game.gameOver()
                }
                if(scene?.game.score != nil){
                    viewController.score = (scene?.game.score)! as Int
                    viewController.time = (scene?.game.totalTime)! as Int
                    viewController.scene = scene!
                }
                //tells the viewcontroller what mode the game was in, so that it can replicate that on replay
                viewController.wasExtreme = extreme
                viewController.wasClassic = classic
            }
        }
    }
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        super.viewDidLoad()
        // Disable ability button if game mode is extreme of classic
        if extreme || classic { //In these cases, we do not want the user clicking on this button.
            abilityButton.isUserInteractionEnabled = false
            abilityButton.alpha = 0
        }
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let newscene = GameScene(fileNamed: "GameScene") {
                if(extreme) {
                    newscene.toggleExtreme()
                }
                else if(classic) {
                    newscene.toggleClassic()
                }

            
                
                scene = newscene   
                //UserDataHolder.shared.currentGameModel = GameModel(start: 1, view: scene as GameScene, isExtreme: extreme, isClassic: classic)
                scene!.quitButton = QuitButton
                scene!.attachAbilityButton(button: abilityButton)

                // Set the scale mode to scale to fit the window
                scene!.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)

            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            //AD.playGameTheme()
            AudioPlayer.shared.playSong("game", exten: "wav", forceReset: true)
        }
    }
    override func viewWillDisappear(_ animated: Bool){
         /*if(AD.audio != nil) {
            //AD.audio!.stop()
        }
         */
        if(scene != nil) {
            scene?.removeFromParent()
            scene!.destroySelf()
            scene = nil
        } else{
            print("Scene is nil!")
        }
        super.viewWillDisappear(animated)
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
