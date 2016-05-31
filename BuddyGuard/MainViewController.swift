//
//  MainViewController.swift
//  BuddyGuard
//
//  Created by Justin Salazar on 5/26/16.
//  Copyright © 2016 Stewart Boyd. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, UINavigationControllerDelegate, AVAudioPlayerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.delegate = self;
        let alarm = Alarm(volume: 1.0);
        alarm.play()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false;
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true;
    }

    /*
    // MARK: - Navigation
     
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if (flag == true){
            print("Completed playing audio player");
        }
    }
    
    

}
