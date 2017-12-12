//
//  AbilityModel.swift
//  Switch
//
//  Created by student on 11/15/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit

class AbilityModel {
    //This is the base class for all abilities. It contains logic for a warmup period after the ability is used before which the ability can be used again, as well as some accessors
    var image: String! = nil
    var name: String! = "default name"
    var desc: String! = "default description"
    var cost: Int! = 0
    var level: Int! = 1 //level isn't currently used for anything, but was intended to scale the ability's effects
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
    //This is polymorphically defined in all child classes. The child class's definition should call the parent class, and only execute its implementation of the ability if the parent returns true
        if abilityReady {
            abilityReady = false
            timer = Timer.scheduledTimer(timeInterval: abilityDuration + warmUpTime, target: self, selector: (#selector(enableAbility)), userInfo: nil, repeats: false)
            UserDataHolder.shared.currentGameModel?.runAbilityStopwatchAnimation(duration: abilityDuration + warmUpTime)
            return true //child's doAbility function should do ability stuff
        }else{
            return false //child's doAbility function should not do ability stuff
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
