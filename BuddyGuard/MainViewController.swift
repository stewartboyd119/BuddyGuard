//
//  MainViewController.swift
//  BuddyGuard
//
//  Created by Justin Salazar on 5/26/16.
//  Copyright © 2016 Stewart Boyd. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController ,UINavigationControllerDelegate, AVAudioPlayerDelegate {
    
    let MyKeychainWrapper = KeychainWrapper()

    var alarm : Alarm!;
    var fader : Fader!;
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var createPwButton: UIButton!
    @IBAction func testClick(sender: UIButton) {
        print("The test button was clicked")
        let fpath = NSBundle.mainBundle().pathForResource("test", ofType: "mp3")
        do{
            alarm = try Alarm(fpath : fpath, volume : 0.0);
        }
        catch _ {
            print("alarm fucked up")
        }
        fader = Fader(player: alarm.audio_player)
        alarm.play_with_fade(fader, onFinished: alarm.stop_if_true)
        //fader.fade(fromVolume: 0.0, toVolume: 1.0);
        //fader.fade(onFinished: alarm.stop_if_true)
        
        //print("The sound was able to play \(played)")
        print("Completed playing")
    }
    
    @IBAction func lockButton(sender: UIButton) {
        
        
        //create alert password not created.
        if !hasPw(){
            let alert = UIAlertController(title: "Error", message: "You must create a password in order to activate the lock.", preferredStyle: .Alert)
            let alertAction  = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.delegate = self;
     
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
        
        if hasPw(){
            createPwButton.hidden = true
        }
        
    }
    
    // The following just checks to see if a password is made.
    func hasPw() -> Bool{
        //probably best to just save pw to "default" as user doesn't need personal account.
        return NSUserDefaults.standardUserDefaults().objectForKey("default") != nil
    }

    /*
    // MARK: - Navigation
     
    
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue){}
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if (flag == true){
            print("Completed playing audio player");
        }
    }
    
    

}
