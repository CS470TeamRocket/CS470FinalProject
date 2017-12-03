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
    var scene : GameScene?
    var audio: AVAudioPlayer?
    
    @IBAction func quit(_ sender: UIButton) {
        //audio!.stop()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settings" {
            if let viewController = segue.destination as? SettingsViewController {
                if(audio != nil){
                    viewController.audio = audio! as AVAudioPlayer
                }
            }
        }
        if segue.identifier == "gameOver" {
            if let viewController = segue.destination as? GameOverViewController {
                if(scene?.game.score != nil){
                    viewController.score = (scene?.game.score)! as Int
                }
                if(audio != nil){
                    viewController.audio = audio! as AVAudioPlayer
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let newscene = GameScene(fileNamed: "GameScene") {
                scene = newscene
                scene?.quitButton = QuitButton
                // Set the scale mode to scale to fit the window
                scene!.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)

            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            playGameTheme()

        }
    }
    override func viewWillDisappear(_ animated: Bool){
        if(audio != nil) {
            audio!.stop()
        }
        if(scene != nil) {
            scene!.destroySelf()
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
    
    
    func playGameTheme() {
        do {
            if let url : URL = Bundle.main.url(forResource: "game", withExtension: "wav", subdirectory:""){
                try audio = AVAudioPlayer(contentsOf: url)
            }
            else {
                print ("URL was not successfully generated")
            }
        }catch{
            print("An error has occurred.")
        }
        
        if(audio != nil){
            audio!.numberOfLoops = -1
            audio!.play()
        }
        else {
            print("Error initializing Audio Player")
        }
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
