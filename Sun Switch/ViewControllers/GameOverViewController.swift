//
//  SettingsViewController.swift
//  Switch
//
//  Created by Maurice Baldain on 11/8/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit
import AVFoundation

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var popBackButton: UIButton!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var HiScoreLabel: UILabel!
    @IBOutlet weak var BestTimeLabel: UILabel!
    @IBOutlet weak var CoinsLabel: UILabel!
    @IBOutlet var Buttons: [roundedButton]!
    var audio: AVAudioPlayer?
    var score: Int = 0
    var time: Int = 0
    
    @IBAction func stop(_ sender: roundedButton) {
        audio!.stop()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if score > UserDefaults.standard.integer(forKey: UserDataHolder.shared.BEST_SCORE_KEY) {
            UserDefaults.standard.set(score, forKey: UserDataHolder.shared.BEST_SCORE_KEY)
        }
        if time > UserDefaults.standard.integer(forKey: UserDataHolder.shared.BEST_TIME_KEY) {
            UserDefaults.standard.set(time, forKey: UserDataHolder.shared.BEST_TIME_KEY)
        }
        ScoreLabel.text = String(score)
        TimeLabel.text = String(time)
        HiScoreLabel.text = String(UserDefaults.standard.integer(forKey: UserDataHolder.shared.BEST_SCORE_KEY))
        BestTimeLabel.text = String(UserDefaults.standard.integer(forKey: UserDataHolder.shared.BEST_TIME_KEY))
        CoinsLabel.text = String(score/100)
        //popBack(UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0)))
        // Do any additional setup after loading the view.
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
