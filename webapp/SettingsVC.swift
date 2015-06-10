//
//  SettingsVC.swift
//  webapp
//
//  Created by Timeless on 08/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    
    var settings: [String] = ["Reset my model", "Logout"]
    
    @IBOutlet weak var navigateBar: UINavigationBar!

     @IBOutlet var tableView: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    override func viewDidAppear(animated: Bool) {
        // change width of navigation bar
        navigateBar.frame=CGRectMake(0, 0, 400, 60)
        
        self.view .addSubview(navigateBar)
        
        navigateBar.setBackgroundImage(UIImage(named:"navigation"),
            forBarMetrics: .Default)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = self.settings[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }

    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.row) {
        case 0:
            self.performSegueWithIdentifier("set_model", sender: self)
        case 1:
            var confirmAlert = UIAlertController(title: "Log out", message: "Do you really want to log out?", preferredStyle: .Alert )
            
            confirmAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: processConfirmAlert))
            
            confirmAlert.addAction(UIAlertAction(title: "Wait a sec", style: .Cancel, handler: nil))
            
            self.presentViewController(confirmAlert, animated: true, completion: nil)
        default: ()
        }

    }

    
    
    func processConfirmAlert (alert: UIAlertAction!) {
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        //self.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("set_login", sender: self)
        
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