//
//  UserDataHolder.swift
//  SSP
//
//  Created by student on 11/26/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import Foundation

class UserDataHolder {
    var abilities: [AbilityModel] = []
    var characters: [CharacterModel] = []
    
    static let shared = UserDataHolder() //Singleton for user data
    
    private init () { //Ensures no other instances can be created
    }
    
    func getAbilities() -> [AbilityModel]{
        return abilities
    }
    
    func getCharacters() -> [CharacterModel]{
        return characters
    }
    
    func setAbilities(abilities: [AbilityModel]) {
        self.abilities = abilities
    }
    
    func setCharacters(characters: [CharacterModel]) {
        self.characters = characters
    }
    
    func clearData() {
        self.characters = []
        self.abilities = []
    }
}
