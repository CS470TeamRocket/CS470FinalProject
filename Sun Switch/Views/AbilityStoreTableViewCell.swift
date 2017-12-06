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
    
    func purchase() {
        for i in 0..<UserDataHolder.shared.abilities.count {
            let a = UserDataHolder.shared.getAbility(idx: i)
            var currency = UserDefaults.standard.integer(forKey: UserDataHolder.shared.TOTAL_CURRENCY)
            if a.getName() == self.AbilityName.text, a.cost <= currency {
                UserDataHolder.shared.buyAbility(ability: a)
                currency = currency - a.cost
                return
            }
        }
    }
    
    func useAbility(ability: AbilityModel){
        self.AbilityImage.image = #imageLiteral(resourceName: "astronaut")
        self.AbilityName.text = ability.getName()
        self.AbilityCost.text = String(ability.getCost())
        self.AbilityDesc.text = ability.getDesc()
    }
}
