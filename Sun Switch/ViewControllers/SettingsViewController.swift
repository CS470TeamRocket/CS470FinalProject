//
//  SettingsViewController.swift
//  Switch
//
//  Created by Maurice Baldain on 11/8/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit
import AVFoundation

class SettingsViewController: UIViewController {

    @IBOutlet weak var popBackButton: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    var audio: AVAudioPlayer?
    
    
    @IBAction func popBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func musicSetting(_ sender: UIButton) {
        if audio != nil {
            if audio!.isPlaying {
                audio!.pause()
            }
            else {
                audio!.play()
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
