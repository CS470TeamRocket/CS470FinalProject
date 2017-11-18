//
//  CharacterCellView.swift
//  SSP
//
//  Created by student on 11/17/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit

class CharacterCellView: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    
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
            cellImage.image = cImage
        }
        cellLabel.text = char.getName()
    }
}
