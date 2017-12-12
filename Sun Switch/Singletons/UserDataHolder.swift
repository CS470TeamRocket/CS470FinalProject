//
//  UserDataHolder.swift
//  SSP
//
//  Created by student on 11/26/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import Foundation

struct Defaults {
    static let bestScore: Int = 0
    static let bestTime: Int = 0
    static let TotalCurrency: Int = 50000
    static let unlockedChars : [Int] = [1, 2]
    static let unlockedBonuses: [Int] = [1, 2]
    //let characters : [CharacterModel]
    //let lockedChars : [CharacterModel]
}

class UserDataHolder {

    //keys for storing objects in UserDefaults
    let BEST_SCORE_KEY:String = "bestScore"
    let BEST_TIME_KEY:String = "bestTime"
    let LAUNCHED_BEFORE_KEY:String = "launchedBefore"
    let TOTAL_CURRENCY:String = "totalCurrency"
    let UNLOCKED_CHARACTERS:String = "u_character_id" //ints
    let UNLOCKED_BONUSES:String = "u_bonus_id"

    //let ABILITY_ID:String = "ability_id" //ints
    //let UNLOCKED:String = "unlocked" // bools
    //let NUM_UNLOCKED_CHARACTERS:String = "numCharacters"
    //let LOCKED_CHARACTERS_ID:String = "l_character_id" //ints
    //let CHARACTER_ID:String = "character_id" //ints
    
    
    //Data which is hardcoded and represents total lists
    var characters: [CharacterModel] = []
    var abilities: [AbilityModel] = []
    var bonuses: [BonusModel] = [GetPointsBonus(), DropBombBonus()]
    
    //Data which is stored and loaded from the user default storage:
    var unlockedCharId: [Int] = []
    var unlockedBonusId: [Int] = []
    var highScore: Int = 0
    var wallet: Int = 0
    var bestTime : Int = 0
    
    //Data which is derived from loaded data and possibly editted during app runtime.
    var unlockedBonuses: [BonusModel] = []
    var lockedBonuses: [BonusModel] = []
    var unlockedCharacters: [CharacterModel] = []
    var lockedCharacters: [CharacterModel] = []
    var sfxVolume: Double = 100
    var musicVolume: Double = 100
    var sfxMuted: Bool = false
    var musicMuted: Bool = false
    
    //Data which is decided and mutable between games.
    var currentCharacter: CharacterModel?
    var currentGameModel: GameModel?
    
    static let shared = UserDataHolder() //Singleton for user data
    
    private init () { //Ensures no other instances can be created
    generateDummy()
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

    func unlockCharacter(_ char: CharacterModel, save: Bool) {
        unlockedCharacters.append(char)
        for i in 0..<lockedCharacters.count {
            if(lockedCharacters[i].id == char.id) {
                lockedCharacters.remove(at: i)
                break
            }
        }
        if(save) {
            var index = [Int]()
            for c in unlockedCharacters {
                index.append(c.id)
            }
            index.sort()
            updateCharacters(index, save: true)
        }
        unlockedCharacters.sort {return $0.id < $1.id}
    }
    
    func unlockBonus(_ bonus: BonusModel, save: Bool) {
        unlockedBonuses.append(bonus)
        for i in 0..<lockedBonuses.count {
            if(lockedBonuses[i].bonusId == bonus.bonusId) {
                lockedCharacters.remove(at: i)
                break
            }
        }
        if(save) {
            var index = [Int]()
            for b in unlockedBonuses {
                index.append(b.bonusId)
            }
            updateBonuses(index, save: true)
        }
    }
    
    func loadFromData() {
        if let launchedBefore: Bool = UserDefaults.standard.bool(forKey: LAUNCHED_BEFORE_KEY) as Bool?{
            if(launchedBefore) {
                print("Not First Launch")
                loadRecords()
                loadUnlockedCharacters()
                loadUnlockedBonuses()
                loadMiscSettings()
            }
            else {
                print("First Launch!")
                resetUserDefaults()
            }
        }
        else {
            print("First Launch")
            resetUserDefaults()
        }
            
    }
    
    func loadRecords() {
        if let hiScore = UserDefaults.standard.integer(forKey: BEST_SCORE_KEY) as Int? {
            highScore = hiScore
        }else{ highScore = 0}
        
        if let nuTime = UserDefaults.standard.integer(forKey: BEST_TIME_KEY) as Int?{
            bestTime = nuTime
        }else{bestTime = 0}
        
        if let dosh = UserDefaults.standard.integer(forKey: TOTAL_CURRENCY) as Int? {
            wallet = dosh
        }else{wallet = 0}
    }
    
    func loadUnlockedCharacters() {
        var unlocked : [Int]
        if let u = UserDefaults.standard.object(forKey: UNLOCKED_CHARACTERS) as! [Int]? {
            unlocked = u
            lockedCharacters.removeAll()
        }
        else {
            unlocked = Defaults.unlockedChars
            lockedCharacters.removeAll()
        }
    
        for c in characters {
            var found : Bool = false
            for i in unlocked{
                if(c.id == i) {
                    unlockCharacter(c, save: false)
                    found = true
                }
            }
            if(!found) {
                lockedCharacters.append(c)
            }
        }
    }
    
    func loadUnlockedBonuses() {
        var unlocked : [Int]
        if let u = UserDefaults.standard.object(forKey: UNLOCKED_BONUSES) as! [Int]? {
            unlocked = u
            lockedBonuses.removeAll()
        }
        else {
            unlocked = Defaults.unlockedBonuses
            lockedBonuses.removeAll()
        }
        for b in bonuses {
            var found: Bool = false
            for i in unlocked {
                if(b.bonusId == i) {
                    unlockBonus(b, save: false)
                    found = true
                }
            }
            if(!found) {
                lockedBonuses.append(b)
            }
        }
    }
    
    func loadMiscSettings() {
    
    }
    
    func resetUserDefaults() {
        print("RESET")
        updateScore(Defaults.bestScore, save: false)
        updateTime(Defaults.bestTime, save: false)
        updateCharacters(Defaults.unlockedChars, save: false)
        updateBonuses(Defaults.unlockedBonuses, save: false)
        updateMoney(Defaults.TotalCurrency, save: false)
        UserDefaults.standard.set(true, forKey: LAUNCHED_BEFORE_KEY)
        UserDefaults.standard.synchronize()
        loadFromData()
        //UserDefaults.standard.set(Int(0),forKey: UserDataHolder.shared.BEST_SCORE_KEY)
        //UserDefaults.standard.set(Int(0),forKey: UserDataHolder.shared.BEST_TIME_KEY)
        //UserDefaults.standard.set(Int(50000), forKey: UserDataHolder.shared.TOTAL_CURRENCY)
        //UserDefaults.standard.set(Int(2), forKey: UserDataHolder.shared.NUM_UNLOCKED_CHARACTERS)
        //UserDefaults.standard.set([], forKey: UserDataHolder.shared.CHARACTER_ID)
        //UserDefaults.standard.set([], forKey: UserDataHolder.shared.LOCKED_CHARACTERS_ID)
        //UserDefaults.standard.set([], forKey: UserDataHolder.shared.UNLOCKED_CHARACTER_ID)
        //UserDefaults.standard.set([], forKey: UserDataHolder.shared.ABILITY_ID)
        //UserDefaults.standard.set([true, true, false, false], forKey: UserDataHolder.shared.UNLOCKED)
        //UserDefaults.standard.set(true, forKey: LAUNCHED_BEFORE_KEY)
        //UserDefaults.standard.synchronize()
        //UserDataHolder.shared.updateCharacters(characters: UserDataHolder.shared.characters)
        //UserDataHolder.shared.updateAllSets()
    }
    
    func generateDummy() {
        for i in 0...7 { //generating some characters
            
            switch i{
                
            case 0:
                let c = CharacterModel(img: "Chrona.png", name: "Chrona, Time Wizard", ability: TimeStopAbility(id: i),desc: "A reclusive and mysterious figure, gifted with unusual powers over the flow of time itself.", unlocked: true, id: i+1, cost: 5000)
                 characters.append(c)
            case 1:
                let c = CharacterModel(img: "Captain Pointman.png", name: "Captain Pointman", ability:
                    PointBoostAbility(id: i),desc: "A hero to the people, rallying the forces of good against the forces of evil.", unlocked: true, id: i+1, cost: 0)
                 characters.append(c)
                
            case 2:
                let c = CharacterModel(img: "Doc Boom.png", name: "Doc Boom", ability: DropBombAbility(id: i),desc: "A mad scientist, bent on vengeance, the pursuit of higher knowledge, and explosions.", unlocked: true, id: i+1, cost: 500)
                 characters.append(c)
            case 3:
                let c = CharacterModel(img: "Geremlo.png", name: "Geremlo the Wanderer", ability:
                    TeleportAbility(id: i),desc: "Thousands of lightyears from his homeworld, he seeks to return to his land once more.", unlocked: false, id: i+1, cost: 1500)
                 characters.append(c)
            case 4:
                let c = CharacterModel(img: "Xarvok.png", name: "Xarvok the Destroyer", ability: ClusterBombAbility(id: i),desc: "A warlord with an insatiable bloodlust. Longs to see the galaxy rendered to dust, with himself reigning supreme.", unlocked: false, id: i+1, cost: 7500)
                 characters.append(c)
            case 5:
                let c = CharacterModel(img: "Nikita.png", name: "Nikita, Heavenly Blade", ability: ColumnWipeAbility(id: i),desc: "An unparalleled swordswoman, seeking the one who killed her master many years ago.", unlocked: false, id: i+1, cost: 3000)
                characters.append(c)
            case 6:
                let c = CharacterModel(img: "H47-E.png", name: "H47-E, Steelwrought Overlord", ability: RowWipeAbility(id: i),desc: "A cold, authoritative general of an endless army of steel. He longs to bring all the universe to clockwork efficiency.", unlocked: false, id: i+1, cost: 5000)
                characters.append(c)
            case 7:
                let c = CharacterModel(img: "Overseer", name: "The Overseer", ability: RowRestoreAbility(id: i),desc: "A mysterious and powerful figure. Little is known of it, but nothing escapes its gaze.", unlocked: false, id: i+1, cost: 7500)
                characters.append(c)
            default:
                return
            }
        }
        characters.sort {return $0.cost < $1.cost}
    }
    
    func updateScore(_ newScore: Int, save: Bool) {
        UserDefaults.standard.set(newScore, forKey: BEST_SCORE_KEY)
        if(save) {
            UserDefaults.standard.synchronize()
        }
    }
    
    func updateTime(_ newTime: Int, save: Bool) {
        UserDefaults.standard.set(newTime, forKey: BEST_TIME_KEY)
        if(save) {
            UserDefaults.standard.synchronize()
        }
    }
    
    func updateMoney(_ lodsofemone: Int, save: Bool) {
        UserDefaults.standard.set(lodsofemone, forKey: TOTAL_CURRENCY)
        if(save) {
            UserDefaults.standard.synchronize()
        }
    }
    func updateCharacters(_ unlocked: [Int], save: Bool) {
        UserDefaults.standard.set(unlocked, forKey: UNLOCKED_CHARACTERS)
        if(save) {
            UserDefaults.standard.synchronize()
        }
    }
    
    func updateBonuses(_ unlocked: [Int], save: Bool) {
        UserDefaults.standard.set(unlocked, forKey: UNLOCKED_BONUSES)
        if(save) {
            UserDefaults.standard.synchronize()
        }
    }
    
    func spend(_ amount: Int) {
        wallet -= amount
        updateMoney(wallet, save: true)
    }
    func earn(_ amount: Int) {
        wallet += amount
        updateMoney(wallet, save: true)
    }
    
    /*
    func loadCharacterData() {
        var json: [Any]?
        do {
            json = try JSONSerialization.jsonObject(with: data)
        }
    }
     */
    
    /*
     
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
     */

}
