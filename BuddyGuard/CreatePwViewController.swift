//
//  CreatePwViewController.swift
//  BuddyGuard
//
//  Created by Justin Salazar on 6/6/16.
//  Copyright © 2016 Stewart Boyd. All rights reserved.
//


import UIKit

class CreatePwViewController: UIViewController {
    
    let MyKeychainWrapper = KeychainWrapper()

    @IBOutlet weak var password: UITextField!
    
    @IBAction func writePw(sender: UITextField) {
        password.becomeFirstResponder()
    }
    
    @IBAction func savePw(sender: UIButton) {
        
        if (password.text == "" || password.text?.characters.count != 4){
            let alertView = UIAlertController(title: "Invalid Password", message: "Password must be a 4 digit number" as String, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            return;
            
        }
        password.resignFirstResponder()
        
        
        if NSUserDefaults.standardUserDefaults().objectForKey("default") == nil {
            NSUserDefaults.standardUserDefaults().setValue(self.password.text, forKey: "default")
        }
        MyKeychainWrapper.mySetObject(password.text, forKey: kSecValueData)
        MyKeychainWrapper.writeToKeychain()
        
        performSegueWithIdentifier("unwindToMain", sender: self)
        
        
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
