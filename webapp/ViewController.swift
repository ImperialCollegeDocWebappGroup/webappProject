//
//  ViewController.swift
//  webapp
//
//  Created by Shan, Jinyi on 25/05/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    var portNumber = 1111
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterButton.layer.cornerRadius = 5
        logoutButton.layer.cornerRadius = 5
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.blackColor()]
        
        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
            self.usernameLabel.text = prefs.valueForKey("USERNAME") as! NSString as String
        }
    }
    
    @IBAction func LogoutTapped(sender: UIButton) {
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
    
    
}

