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
    let LOCKED_CHARACTERS_ID:String = "l_character_id" //ints
    let UNLOCKED_CHARACTER_ID:String = "u_character_id" //ints
    let CHARACTER_ID:String = "character_id" //ints
    let ABILITY_ID:String = "ability_id" //ints
    let UNLOCKED:String = "unlocked" // bools
    //

    
    var abilities: [AbilityModel] = []
    var characters: [CharacterModel] = []
    var unlockedCharacters: [CharacterModel] = []
    var lockedCharacters: [CharacterModel] = []
    var currentCharacter: CharacterModel?
    var currentGameModel: GameModel?
    var sfxVolume: Double = 100
    var musicVolume: Double = 100
    var sfxMuted: Bool = false
    var musicMuted: Bool = false
    
    
    func removeWith(id: Int) {
        for i in 0..<abilities.count{
            if abilities[i].id == id {
                abilities.remove(at: i)
                return
            }
        }
    }
    
    func updateCharacters(characters: [CharacterModel]) {
        clearData()
        fixBools()
        let boo = UserDefaults.standard.object(forKey: UNLOCKED) as? [Bool]
        print("1->", boo)
        print("4->", characters)
        var chars: [Int] = []
        var uchars: [Int] = []
        var lchars: [Int] = []
        var abis: [Int] = []
        var boos: [Bool] = []
        print(abilities)
        for c in characters {
            print(c.unlocked)
            chars.append(c.id)
            abis.append(c.ability.id)
            if c.unlocked! {
                print("unlocked")
                abis.removeLast()
                uchars.append(c.id)
                unlockedCharacters.append(c)
                removeWith(id: c.id)
            }
            else {
                print("locked")
                lchars.append(c.id)
                lockedCharacters.append(c)
            }
            boos.append(c.unlocked)
        }
        print("L",lockedCharacters)
        print("U",unlockedCharacters)
        print("->", boos)
        UserDefaults.standard.set(chars, forKey: CHARACTER_ID)
        UserDefaults.standard.set(lchars, forKey: LOCKED_CHARACTERS_ID)
        UserDefaults.standard.set(uchars, forKey: UNLOCKED_CHARACTER_ID)
        UserDefaults.standard.set(abis, forKey: ABILITY_ID)
        UserDefaults.standard.set(boos, forKey: UNLOCKED)
        let boom = UserDefaults.standard.object(forKey: UNLOCKED) as! [Bool]
        print(boom)
        UserDefaults.standard.synchronize()
        
        
        //UserDefaults.standard.set(characters, forKey: UserDataHolder.shared.CHARACTERS)
    }
    func updateLCharacters(characters: [CharacterModel]) {
        //UserDefaults.standard.set(characters, forKey: UserDataHolder.shared.LOCKED_CHARACTERS)
    }
    func updateUCharacters(characters: [CharacterModel]) {
        //UserDefaults.standard.set(characters, forKey: UserDataHolder.shared.UNLOCKED_CHARACTERS)
    }
    func updateAbilities(abilities: [AbilityModel]) {
        //UserDefaults.standard.set(abilities, forKey: UserDataHolder.shared.ABILITIES)
    }
    func updateAllSets() {
        updateCharacters(characters: characters)
        updateLCharacters(characters: lockedCharacters)
        updateUCharacters(characters: unlockedCharacters)
        updateAbilities(abilities: abilities)
    }
    
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
        return AbilityModel(id: idx)
    }
    
    func getCharacters() -> [CharacterModel]{
        return characters
    }
    
    func getUnlockedCharacters() -> [CharacterModel]{
        return unlockedCharacters
    }
    
    func getLockedCharacters() -> [CharacterModel]{
        return lockedCharacters
    }
    
    func buyAbility(ability: AbilityModel) {
        for c in characters {
            if c.ability.name == ability.name {
                c.unlocked = true
                unlockAbility(name: ability.name)
                return
            }
        }
    }
    
    func setAbilities(abilities: [AbilityModel]) {
        self.abilities = abilities
        //updateAbilities(abilities: abilities)
    }
    
    func setCharacters(characters: [CharacterModel]) {
        self.characters = characters
        //updateCharacters(characters: characters)
    }
    
    func setUnlockedCharacters(characters: [CharacterModel]) {
        self.unlockedCharacters = characters
        //updateUCharacters(characters: characters)
    }

    func setLockedCharacters(characters: [CharacterModel]) {
        self.lockedCharacters = characters
        //updateLCharacters(characters: characters)
    }
    
    func unlockAbility(name: String) {
        for c in 0..<abilities.count {
            if abilities[c].name == name {
                //unlockedCharacters.append(lockedCharacters[c])
                //lockedCharacters.remove(at: c)
                //abilities.remove(at: c)
                print("*",c)
                updateBools(idx: c)
                updateCharacters(characters: characters)
                //updateAllSets()
                return
            }
        }
    }
    
    func clearData() {
        //self.characters = []
        //self.abilities = []
        self.unlockedCharacters = []
        self.lockedCharacters = []
    }
    
    func updateBools(idx: Int) {
        let oldBools = UserDefaults.standard.object(forKey: UNLOCKED)  as? [Bool] ?? [Bool]()
        print("2->", oldBools)
        if oldBools.count != 0 {
            var new: [Bool] = oldBools
            new[idx] = true
            UserDefaults.standard.set(new, forKey: UNLOCKED)
        }
    }
    
    func fixBools() {
        if let oldBools = UserDefaults.standard.object(forKey: UNLOCKED) as? [Bool] {
            for c in 0..<characters.count {
                characters[c].unlocked = oldBools[c]
            }
        }
        else {
            let oldBools = Defaults.unlockedChars
            for c in 0..<characters.count {
                characters[c].unlocked = oldBools[c]
            }
            //Data is corrupted. Reset.

        }
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
