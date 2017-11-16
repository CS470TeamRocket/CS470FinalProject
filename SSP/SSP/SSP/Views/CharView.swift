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
    let name: String!
    let ability: String!
    let desc: String!
    
    init(frame: CGRect, image: UIImage, name: String, ability: String, desc: String) {
        self.img = image
        self.name = name
        self.ability = ability
        self.desc = desc
        super.init(frame: frame)
        self.layer.cornerRadius = 10
    }
    
    required init(coder decoder: NSCoder) {
        self.img = nil
        self.name = nil
        self.ability = nil
        self.desc = nil
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
