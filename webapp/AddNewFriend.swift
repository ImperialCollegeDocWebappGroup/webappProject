//
//  AddNewFriend.swift
//  webapp
//
//  Created by Zhang, Zhuofan on 04/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class AddNewFriend: UIViewController {

    @IBOutlet weak var searchUsername: UITextField!
    @IBOutlet weak var foundLabel: UIButton!
    var fri : String = ""
    
    @IBOutlet weak var doneButt: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        foundLabel.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func foundPressed(sender: UIButton) {
         // code to send friend request
        let alertController = UIAlertController(title: "friend added", message:
            fri + " is now your friend", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    @IBAction func doneButtTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func searchPressed(sender: UIButton) {
        
        var searchContent = searchUsername.text
        
        if  searchContent! != "" {
            var found = true
            // condition to see if match found
            if found {
                foundLabel.hidden = false
                let display = searchContent! + " is found, click here to add"
                foundLabel.setTitle(display, forState: .Normal)
                fri = searchContent!
            } else {
                
                let alertController = UIAlertController(title: "Not Found", message:
                    searchContent! + " is not found!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
            
        } else {
            let alertController = UIAlertController(title: "Not Null", message:
                "username can not be empty", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
        }

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
