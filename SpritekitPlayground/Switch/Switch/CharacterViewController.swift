//
//  CharacterViewController.swift
//  Switch
//
//  Created by Maurice Baldain on 11/8/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit

class CharacterViewController: UIViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var bigImg: UIImageView!
    
    @IBOutlet var chars: [UIImageView]!
    
    @IBOutlet var abilityButtons: [UIButton]!
    
    @IBAction func choseCharacter(_ sender: UIButton) {
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainScrollView.frame = view.frame
        print(mainScrollView.frame)
        mainScrollView.contentSize.height = bigImg.frame.size.height
        print(bigImg)
        print(mainScrollView.contentSize)
    }
    
    func loadCharacterViews() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
