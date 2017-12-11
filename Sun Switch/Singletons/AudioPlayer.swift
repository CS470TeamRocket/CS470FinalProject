//
//  AudioPlayer.swift
//  Sun Switch
//
//  Created by student on 12/7/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer {
    var audio: AVAudioPlayer?
    var AVS: String = ""
    
    static let shared : AudioPlayer = AudioPlayer()
    
    func playTitleTheme() {
        if AVS != "title2" {
            print("A: \(audio)")
            do {
                if let url : URL = Bundle.main.url(forResource: "title2", withExtension: "wav", subdirectory:""){
                    if audio != nil{
                        print("TRYING TO STOP!")
                        audio!.stop()
                        audio = nil
                    }
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
                AVS = "title2"
                if UserDataHolder.shared.musicMuted {
                    audio!.pause()
                }
            }
            else {
                print("Error initializing Audio Player")
            }
        }
        else {
            print("ALREADY PLAYING THIS SONG!!")
        }
    }
    
    func playGameTheme() {
        if AVS != "game" {
            do {
                if let url : URL = Bundle.main.url(forResource: "game", withExtension: "wav", subdirectory:""){
                    if audio != nil{
                        audio!.stop()
                        audio = nil
                    }
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
                AVS = "game"
                if UserDataHolder.shared.musicMuted {
                    audio!.pause()
                }
            }
            else {
                print("Error initializing Audio Player")
            }
        }
        else {
            print("ALREADY PLAYING THIS SONG!!")
        }
    }
}
