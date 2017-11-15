//
//  AbilityModel.swift
//  Switch
//
//  Created by student on 11/15/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import Foundation

class AbilityModel {
    var image: String! = nil
    var name: String! = nil
    var desc: String! = nil
    var level: Int! = nil
    
    init() {
        
    }
    
    func doAbility(){
        
    }
    
    func getImage() -> String {
        return image
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
    
    func setLevel(level: Int){
        self.level = level
    }
    
    func serialize() -> String {
        return "" //Should put all core info into a string
    }
}
