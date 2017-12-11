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
    var id: Int!
    var cost: Int!
    
    init(img: String, name: String, ability: AbilityModel, desc: String, unlocked: Bool, id: Int, cost: Int) {
        self.img = img
        self.name = name
        self.ability = ability
        self.desc = desc
        self.unlocked = unlocked
        self.id = id
        self.cost = cost
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
    
    func getCost() -> Int {
        return cost
    }
    
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "name") as! String
        self.img = decoder.decodeObject(forKey: "img") as! String
        self.desc = decoder.decodeObject(forKey: "desc") as! String
        self.unlocked = decoder.decodeObject(forKey: "unlocked") as! Bool
        self.ability = decoder.decodeObject(forKey: "ability") as! AbilityModel
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.img, forKey: "img")
        coder.encode(self.desc, forKey: "desc")
        coder.encode(self.unlocked, forKey: "unlocked")
        coder.encode(self.ability, forKey: "ability")
    }
}
