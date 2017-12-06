//
//  UserDataHolder.swift
//  SSP
//
//  Created by student on 11/26/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import Foundation

class UserDataHolder {

    //keys for storing objects in UserDefaults
    let BEST_SCORE_KEY:String = "bestScore"
    let BEST_TIME_KEY:String = "bestTime"
    let LAUNCHED_BEFORE_KEY:String = "launchedBefore"
    let TOTAL_CURRENCY:String = "totalCurrency"
    let NUM_UNLOCKED_CHARACTERS:String = "numCharacters"
    //

    
    var abilities: [AbilityModel] = []
    var characters: [CharacterModel] = []
    var unlockedCharacters: [CharacterModel] = []
    var currentCharacter: CharacterModel?
    var currentGameModel: GameModel?
    var sfxVolume: Double = 100
    var musicVolume: Double = 100
    var sfxMuted: Bool = false
    var musicMuted: Bool = false
    
    
    static let shared = UserDataHolder() //Singleton for user data
    
    private init () { //Ensures no other instances can be created
    }
    
    func getAbilities() -> [AbilityModel]{
        return abilities
    }
    
    func getAbility(idx: Int) -> AbilityModel {
        if abilities[idx].name != "default name" {
            let a = abilities[idx]
            return a
        }
        return AbilityModel()
    }
    
    func getCharacters() -> [CharacterModel]{
        return characters
    }
    
    func getUnlockedCharacters() -> [CharacterModel]{
        return unlockedCharacters
    }
    
    func unlockChar() {
        
    }
    
    func buyAbility(ability: AbilityModel) {
        for c in characters {
            if c.ability.name == ability.name {
                c.unlocked = true
                unlockedCharacters.append(c)
            }
        }
    }
    
    func setAbilities(abilities: [AbilityModel]) {
        self.abilities = abilities
    }
    
    func setCharacters(characters: [CharacterModel]) {
        self.characters = characters
    }
    
    func setUnlockedCharacters(characters: [CharacterModel]) {
        self.unlockedCharacters = characters
    }
    
    func clearData() {
        self.characters = []
        self.abilities = []
        self.unlockedCharacters = []
    }
    /*
    func loadCharacterData() {
        var json: [Any]?
        do {
            json = try JSONSerialization.jsonObject(with: data)
        }
    }
     */
}
