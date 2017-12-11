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
    //let AD = UIApplication.shared.delegate as! AppDelegate
    //var audio: AVAudioPlayer?
    var score: Int = 0
    var time: Int = 0
    
    @IBAction func stop(_ sender: roundedButton) {
        AudioPlayer.shared.playSong("title2", exten: "wav", forceReset: false)
        //AD.playTitleTheme()
        UserDataHolder.shared.currentCharacter = nil
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var newScore = false
        var newTime = false
        let oldTotal = UserDefaults.standard.integer(forKey: UserDataHolder.shared.TOTAL_CURRENCY)
        let oldTime = UserDefaults.standard.integer(forKey: UserDataHolder.shared.BEST_TIME_KEY)
        let oldScore = UserDefaults.standard.integer(forKey: UserDataHolder.shared.BEST_SCORE_KEY)
        if score > oldScore {
            newScore = true
            UserDefaults.standard.set(score, forKey: UserDataHolder.shared.BEST_SCORE_KEY)
        }
        if time > oldTime {
            newTime = true
            UserDefaults.standard.set(time, forKey: UserDataHolder.shared.BEST_TIME_KEY)
        }
        let newCoins = (score+50)/100
        let coins = oldTotal + newCoins
        UserDefaults.standard.set(coins, forKey: UserDataHolder.shared.TOTAL_CURRENCY)
        ScoreLabel.text = String(score)
        TimeLabel.text = String(time)
        let highScore = UserDefaults.standard.integer(forKey: UserDataHolder.shared.BEST_SCORE_KEY)
        HiScoreLabel.text = String(highScore)
        let bestTime = UserDefaults.standard.integer(forKey: UserDataHolder.shared.BEST_TIME_KEY)
        BestTimeLabel.text = String(bestTime)
        CoinsLabel.text = "\(oldTotal)"
        print(score)
        if newScore {
            countUpAnimation(label: HiScoreLabel, oldTotal: oldScore, currentTotal: oldScore+50, newTotal: highScore, ix: 50)
        }
        if newTime {
            countUpAnimation(label: BestTimeLabel, oldTotal: oldTime, currentTotal: oldTime+1, newTotal: bestTime, ix: 1)
        }
        if newCoins > 0 {
            countUpAnimation(label: CoinsLabel, oldTotal: oldTotal, currentTotal: oldTotal, newTotal: coins, ix: 1)
        }
        //popBack(UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0)))
        // Do any additional setup after loading the view.
    }
    
    func countUpAnimation(label: UILabel, oldTotal: Int, currentTotal: Int, newTotal: Int, ix: Int) {
        if currentTotal + ix <= newTotal {
            UIView.animate(withDuration: 1, animations: {
                label.text = "\(oldTotal) -> \(currentTotal+ix)"
            }, completion: { finished in
                self.countUpAnimation(label: label, oldTotal: oldTotal, currentTotal: currentTotal+ix, newTotal: newTotal, ix: ix)
            })
        }
        else if currentTotal != newTotal {
            self.countUpAnimation(label: label, oldTotal: oldTotal, currentTotal: currentTotal+1, newTotal: newTotal, ix: 1)
        }
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
