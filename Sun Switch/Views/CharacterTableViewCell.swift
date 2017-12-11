//
//  CharacterTableViewCell.swift
//  SSP
//
//  Created by student on 11/20/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellDesc: UITextView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var characterAbilityName: UILabel!
    @IBOutlet weak var abilityDesc: UITextView!
    //Stored to be passed to game

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func useCharacter(_ char: CharacterModel) {
        if let cImage = char.getImg()  {
            self.cellImage.image = cImage
        }
        cellTitle.text = char.getName()
        cellDesc.text = char.getDesc()
        characterAbilityName.text = char.getAbility().getName()
        characterAbilityName.isUserInteractionEnabled = true
        abilityDesc.text = char.getAbility().getDesc()
        let abilityTap = UITapGestureRecognizer(target: self, action: #selector(toggleAbilityDesc))
        characterAbilityName.addGestureRecognizer(abilityTap)
        abilityTap.delegate = self
    }
    
    func toggleAbilityDesc() {
        abilityDesc.isHidden = !abilityDesc.isHidden
    }


}
