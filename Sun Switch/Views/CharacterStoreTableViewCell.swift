//
//  CharacterStoreTableViewCell.swift
//  Sun Switch
//
//  Created by student on 12/10/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation
import UIKit

class CharacterStoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var abilityDesc: UITextView!
    @IBOutlet weak var BuyButton: UIButton!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellDesc: UITextView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var characterCost: UITextView!
    @IBOutlet weak var characterAbilityName: UILabel!
    @IBOutlet weak var characterId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func purchase() {
        for c in UserDataHolder.shared.characters {
            if (c.id == Int(characterId.text!)) {
                if(UserDataHolder.shared.wallet >= c.getCost()) {
                    UserDataHolder.shared.spend(c.getCost())
                    UserDataHolder.shared.unlockCharacter(c, save: true)
                }
                return
            }
        }
    }
    
    
    func useCharacter(_ character: CharacterModel){
        self.cellImage.image = character.getImg()
        self.characterAbilityName.text = character.getAbility().getName()
        self.characterCost.text = String( character.getCost())
        self.abilityDesc.text = character.getAbility().getDesc()
        self.cellTitle.text = character.getName()
        self.cellDesc.text = character.getDesc()
        characterId.text = String(character.id)
        let abilityTap = UITapGestureRecognizer(target: self, action: #selector(toggleAbilityDesc))
        characterAbilityName.addGestureRecognizer(abilityTap)
        abilityTap.delegate = self
    }
    
    func toggleAbilityDesc() {
        abilityDesc.isHidden = !abilityDesc.isHidden
    }
}
