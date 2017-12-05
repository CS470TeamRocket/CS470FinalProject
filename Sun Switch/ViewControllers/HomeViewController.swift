//
//  HomeViewController.swift
//  Switch
//
//  Created by Maurice Baldain on 11/7/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit
<<<<<<< HEAD
=======
import AVFoundation

>>>>>>> Zach

class HomeViewController: UIViewController {
    @IBOutlet weak var SUN: UIImageView!
    @IBOutlet weak var SWITCH: UIImageView!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var play: UIButton!
<<<<<<< HEAD

=======
    var audio: AVAudioPlayer?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settings" {
            if let viewController = segue.destination as? SettingsViewController {
                if(audio != nil){
                    viewController.audio = audio! as AVAudioPlayer
                }
            }
        }
    }
>>>>>>> Zach
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SUN.loadGif(name: "s1")
        SWITCH.loadGif(name: "s2")
<<<<<<< HEAD
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
=======
        playTitleTheme()
    }
    override func viewWillDisappear(_ animated: Bool) {
        if(audio != nil) {
            audio!.stop()
        }
        super.viewWillDisappear(animated)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
>>>>>>> Zach
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
<<<<<<< HEAD
    
=======
    func playTitleTheme() {
        do {
            if let url : URL = Bundle.main.url(forResource: "title2", withExtension: "wav", subdirectory:""){
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
>>>>>>> Zach
    
}


