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
    
    @IBAction func choseCharacter(_ sender: UIButton) { }
    
    
    var charachters: [CharView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainScrollView.frame = view.frame
        //print(mainScrollView.frame)
        mainScrollView.contentSize.height = bigImg.frame.size.height
        let x = mainScrollView.frame.width / 15
        var y = mainScrollView.contentSize.height / 15
<<<<<<< HEAD:SSP/SSP/SSP/ViewControllers/CharacterViewController.swift
        for i in 0..<6 {
=======
        for _ in 0..<6 {
>>>>>>> Zach:Sun Switch/ViewControllers/CharacterViewController.swift
            let origin = CGPoint(x: x, y: y)
            let size = CGSize(width: mainScrollView.frame.width - x * 2, height: mainScrollView.contentSize.height / 7)
            let rect = CGRect(origin: origin, size: size)
            print(rect)
            let v = CharView(frame: rect, image: #imageLiteral(resourceName: "helmet"), name: "The Name Goes Here.", ability: "The Name of The Ability", desc: "Yeah, this is the ability. Not my job, apperently.")
            let b = UIView(frame: rect)
            b.layer.cornerRadius = 10
            b.layer.borderWidth = 2
            b.layer.borderColor = UIColor.black.cgColor
            b.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
            mainScrollView.addSubview(b)
            mainScrollView.addSubview(v)
            y += v.frame.size.height + 10
        }
        
        //print(bigImg)
        //print(mainScrollView.contentSize)
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
