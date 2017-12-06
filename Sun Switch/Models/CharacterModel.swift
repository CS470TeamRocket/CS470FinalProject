//
//  CharacterModel.swift
//  Switch
//
//  Created by student on 11/15/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit

class CharacterModel {
    let img: String!
    let name: String!
    var ability: AbilityModel!
    let desc: String!
    var unlocked: Bool!
    
    init(img: String, name: String, ability: AbilityModel, desc: String, unlocked: Bool) {
        self.img = img
        self.name = name
        self.ability = ability
        self.desc = desc
        self.unlocked = unlocked
    }
    
    func getImg() -> UIImage? {
        return UIImage(named: img)
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
