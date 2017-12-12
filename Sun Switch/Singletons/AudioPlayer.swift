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
    var musicPlayer: AVAudioPlayer?
    var sfxPlayer: AVAudioPlayer?
    var currSong: String = ""
    var musicVolume: Float = 100
    var sfxVolume: Float = 100
    
    static let shared : AudioPlayer = AudioPlayer()
    
    private init() {
    }
    
    func playSong(_ title: String, exten: String, forceReset: Bool) {
        if(currSong == title) {
            if let m = musicPlayer{
                if(forceReset) {
                    m.play(atTime: 0)
                    return
                }
            }
        }
        else {
            do {
                if let url : URL = Bundle.main.url(forResource: title, withExtension: exten, subdirectory:""){
                    if let m = musicPlayer{
                        m.stop()
                    }
                    try musicPlayer = AVAudioPlayer(contentsOf: url)
                    musicPlayer!.play()
                    musicPlayer!.numberOfLoops = -1
                    currSong = title
                }
            }catch {
                print("File not found.")
            }
            
        }
    }
    func adjustMusicVolume(_ volume: Float) {
        musicVolume = volume
        setVolume()
    }
    func adjustSfxVolume(_ volume: Float) {
        sfxVolume = volume
        setVolume()
    }
    func pauseMusic()  {
        if let m = musicPlayer {
            if m.isPlaying {
                m.pause()
            }
            else {
                m.play()
            }
        }
    }
    func stop() {
        if let m = musicPlayer {
            m.stop()
        }
    }
    
    func setVolume() {
        if let m = musicPlayer {
            m.setVolume(musicVolume, fadeDuration: 1)
        }
        if let s = sfxPlayer {
            s.setVolume(sfxVolume, fadeDuration: 1)
        }
    }
    /*
    func playTitleTheme() {
        if currSong != "title2" {
            print("A: \(musicPlayer)")
            do {
                if let url : URL = Bundle.main.url(forResource: "title2", withExtension: "wav", subdirectory:""){
                    if musicPlayer != nil{
                        print("TRYING TO STOP!")
                        musicPlayer!.stop()
                    }
                    try musicPlayer = AVAudioPlayer(contentsOf: url)
                }
                else {
                    print ("URL was not successfully generated")
                }
            }catch{
                print("An error has occurred.")
            }
            if(musicPlayer != nil){
                musicPlayer!.numberOfLoops = -1
                musicPlayer!.play()
                currSong = "title2"
                if UserDataHolder.shared.musicMuted {
                    musicPlayer!.pause()
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
        if currSong != "game" {
            do {
                if let url : URL = Bundle.main.url(forResource: "game", withExtension: "wav", subdirectory:""){
                    if musicPlayer != nil{
                        musicPlayer!.stop()
                        musicPlayer = nil
                    }
                    try musicPlayer = AVAudioPlayer(contentsOf: url)
                }
                else {
                    print ("URL was not successfully generated")
                }
            }catch{
                print("An error has occurred.")
            }
            if(musicPlayer != nil){
                musicPlayer!.numberOfLoops = -1
                musicPlayer!.play()
                currSong = "game"
                if UserDataHolder.shared.musicMuted {
                    musicPlayer!.pause()
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
    */
}
