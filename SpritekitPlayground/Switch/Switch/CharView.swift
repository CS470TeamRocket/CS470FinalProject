//
//  CharView.swift
//  Switch
//
//  Created by Maurice Baldain on 11/8/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit

class CharView: UIView {
    let img: UIImage!
    let model: CharacterModel!
    
    init(frame: CGRect, model: CharacterModel) {
        self.img = UIImage(named: model.getImg())
        self.model = model
        super.init(frame: frame)
        self.layer.cornerRadius = 10
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
