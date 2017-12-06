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
    //Should have variable gameModel (named master) to execute doAbility on. Ability will need to receive a gameModel on game start.
    
    init(id: Int) {
        self.id = id
        //super.init()
    }
    
    func doAbility(){
        
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
    
    func LevelUp() {
        self.level = self.level + 1
    }
}
