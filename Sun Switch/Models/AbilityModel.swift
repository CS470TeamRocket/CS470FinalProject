//
//  AbilityModel.swift
//  Switch
//
//  Created by student on 11/15/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit

class AbilityModel {
    var image: String! = nil
    var name: String! = "default name"
    var desc: String! = "default description"
    var cost: Int! = 0
    var level: Int! = 1
    var unlocked: Bool = false
    var id: Int
    var warmUpTime : TimeInterval = 10 //How long to reuse ability after it completes (the ability duration has expired).
    var abilityDuration : TimeInterval = 0 //How long an ability is active. for many abilities it is 0 (like bombs and teleport)
    var timer : Timer = Timer() //Timer that runs warmup time stuff
    var abilityReady : Bool = true //True if the warm up time has expired
    //Should have variable gameModel (named master) to execute doAbility on. Ability will need to receive a gameModel on game start.
    
    init(id: Int) {
        self.id = id
        //super.init()
    }
    
    func doAbility() -> (Bool){
        if abilityReady {
            abilityReady = false
            timer = Timer.scheduledTimer(timeInterval: abilityDuration + warmUpTime, target: self, selector: (#selector(enableAbility)), userInfo: nil, repeats: false)
            return true
        }else{
            return false
        }
    }
    
    @objc func enableAbility() {
        self.abilityReady = true
    }
    
    func getImg() -> UIImage? {
        return UIImage(named: image)
    }
    
    func getName() -> String {
        return name
    }
    
    func getDesc() -> String {
        return desc
    }
    
    func getLevel() -> Int {
        return level
    }
    
    func getCost() -> Int {
        return cost
    }
    
    func setLevel(level: Int){
        self.level = level
    }
    
    func setWarmUpTime(seconds: TimeInterval){
        self.warmUpTime = seconds
    }
    
    func LevelUp() {
        self.level = self.level + 1
    }
}
