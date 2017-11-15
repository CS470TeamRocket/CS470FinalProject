//
//  AbilityView.swift
//  Switch
//
//  Created by student on 11/15/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit

class AbilityView: UIView {
    let model: AbilityModel!
    let img: UIImage!
    
    init(frame: CGRect, abilityModel: AbilityModel) {
        self.img = UIImage(named: abilityModel.getImage())
        self.model = abilityModel
        super.init(frame: frame)
    }
    
    required init(coder decoder: NSCoder) {
        self.img = nil
        self.model = nil
        super.init(coder: decoder)!
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
}
