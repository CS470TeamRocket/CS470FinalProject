//
//  AbilityStoreTableViewCell.swift
//  SSP
//
//  Created by student on 11/24/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit

class AbilityStoreTableViewCell: UITableViewCell {

    @IBOutlet weak var AbilityImage: UIImageView!
    @IBOutlet weak var AbilityName: UITextView!
    @IBOutlet weak var AbilityCost: UITextView!
    @IBOutlet weak var AbilityDesc: UITextView!
    @IBOutlet weak var BuyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func useAbility(ability: AbilityModel){
        self.AbilityImage.image = ability.getImg()
        self.AbilityName.text = ability.getName()
        self.AbilityCost.text = String(ability.getCost())
        self.AbilityDesc.text = ability.getDesc()
    }
}
