//
//  CharView.swift
//  Switch
//
//  Created by Maurice Baldain on 11/8/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit

class CharView: UIView {
    let imgView: UIImageView!
    let img: UIImage!
    let name: String!
    let ability: String!
    let desc: String!
    
    init(frame: CGRect, image: UIImage, name: String, ability: String, desc: String) {
        self.img = image
        self.name = name
        self.ability = ability
        self.desc = desc
        imgView = UIImageView(image: image)
        super.init(frame: frame)
        //var color = UIColor(white: 1, alpha: 0.8)
        //self.backgroundColor = UIColor.gray
        //self.alpha = 0.8
        self.addSubview(imgView)
        self.bringSubview(toFront: imgView)
        //super.bringSubview(toFront: imgView)
        imgView.center.x = image.size.width / 2 + CGFloat(10)
        imgView.center.y = self.center.x
    }
    
    required init(coder decoder: NSCoder) {
        self.img = nil
        self.name = nil
        self.ability = nil
        self.desc = nil
        self.imgView = nil
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
