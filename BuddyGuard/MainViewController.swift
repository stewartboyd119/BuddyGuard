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

    @IBOutlet weak var testButton: UIButton!
    @IBAction func testClick(sender: UIButton) {
        print("The test button was clicked")
        
        do{
            alarm = try Alarm();
        }
        catch _ {
            print("alarm fucked up")
        }
        let played = alarm.play()
        print("The sound was able to play \(played)")
        print("Completed playing")
    }
    
    @IBAction func lockButton(sender: UIButton) {
        
        //check if user: default has a password.  probably best to just save pw to "default" as user doesn't need personal account.
        let hasPassword = NSUserDefaults.standardUserDefaults().boolForKey("default")
        
        //create alert if doesn't exist.  will probably segue into createPw view conntroller.
        if hasPassword == false{
            let alert = UIAlertController(title: "Error", message: "You must create a password in order to activate the lock.", preferredStyle: .Alert)
            let alertAction  = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        performSegueWithIdentifier("armLock", sender: self)
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
