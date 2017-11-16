//
//  CharacterModel.swift
//  Switch
//
//  Created by student on 11/15/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import Foundation

class CharacterModel {
    let img: String!
    let name: String!
    let ability: AbilityModel!
    let desc: String!
    
    init(img: String, name: String, ability: AbilityModel, desc: String) {
        self.img = img
        self.name = name
        self.ability = ability
        self.desc = desc
    }
    
    func getImg() -> String {
        return img
    }
    
    func getName() -> String {
        return name
    }
    
    func getDesc() -> String {
        return desc
    }
    
    func getAbility() -> AbilityModel {
        return ability
    }
}
