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
    @IBOutlet weak var cellTitle: UITextView!
    @IBOutlet weak var characterAbilityName: UITextView!
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
        self.cellTitle.text = char.getName()
        self.cellDesc.text = char.getDesc()
        self.characterAbilityName.text = char.getAbility().getName()
    }

}
