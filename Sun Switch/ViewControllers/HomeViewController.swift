//
//  HomeViewController.swift
//  Switch
//
//  Created by Maurice Baldain on 11/7/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit
import AVFoundation


class HomeViewController: UIViewController {
    @IBOutlet weak var SUN: UIImageView!
    @IBOutlet weak var SWITCH: UIImageView!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var play: UIButton!

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "settings" {
//            if let viewController = segue.destination as? SettingsViewController {
//                if(audio != nil){
//                    viewController.audio = audio! as AVAudioPlayer
//                }
//            }
//        }
//    }
    
    @IBAction func pauseMusic(_ sender: UIButton) {
        AudioPlayer.shared.pauseMusic();
        
        
        /*
        //print(AudioPlayer.shared.audio!)
        if AudioPlayer.shared.musicPlayer != nil {
            if AD.audio!.isPlaying {
                AD.audio!.pause()
                UserDataHolder.shared.musicMuted = true
            }
            else {
                AD.audio!.play()
                UserDataHolder.shared.musicMuted = false
            }
        }*/
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SUN.loadGif(name: "s1")
        SWITCH.loadGif(name: "s2")
        AudioPlayer.shared.playSong("title2", exten: "wav", forceReset: false)
        //AD.playTitleTheme()
    }
    override func viewWillDisappear(_ animated: Bool) {
        //AudioPlayer.shared.stop()
        
        /*if(AD.audio != nil) {
            //audio!.stop()
        }*/
        
        super.viewWillDisappear(animated)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


