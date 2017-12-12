//
//  BonusStoreTableViewCell.swift
//  Sun Switch
//
//  Created by student on 12/11/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class BonusStoreTableViewCell: UITableViewCell {
    @IBOutlet weak var BuyButton: UIButton!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDesc: UITextView!
    @IBOutlet weak var bonusCost: UITextView!
    @IBOutlet weak var bonusId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func purchase() {
        for b in UserDataHolder.shared.bonuses {
            if (b.bonusId == Int(bonusId.text!)) {
                if(UserDataHolder.shared.wallet >= b.getCost()){
                    UserDataHolder.shared.spend(b.getCost())
                    UserDataHolder.shared.unlockBonus(b, save: true)
                }
                return
            }
        }
    }
    
    func useBonus(_ bonus: BonusModel) {
        if let cImage = bonus.getImg() {
            self.cellImage.image = cImage
        }
        cellTitle.text = bonus.getName()
        cellDesc.text = bonus.getDesc()
        cellDesc.text = bonus.getDesc()
        bonusCost.text = String( bonus.getCost())
        bonusId.text = String( bonus.bonusId)
    }
}
