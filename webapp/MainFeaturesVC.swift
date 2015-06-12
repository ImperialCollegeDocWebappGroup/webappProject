//
//  MainFeaturesVC.swift
//  webapp
//
//  Created by Timeless on 03/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class MainFeaturesVC: UIViewController {

    
    @IBOutlet weak var menuButt: UIBarButtonItem!
    
    @IBOutlet weak var dropDownMenu: UITableView!

    @IBOutlet weak var modelView: UIImageView!
    
    @IBOutlet weak var shirtView: UIImageView!
    
    var shirt: UIImage! = nil
    
    var menus:[String] = ["Load Clothing", "Combine with another", "Share to Friends", "Clear Appearance"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButt.setBackgroundImage(UIImage(named: "menu_icon"), forState: .Normal, barMetrics: .Default)
        
        dropDownMenu.hidden = true
        self.navigationItem.title = "FITTING ROOM"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"navigation"), forBarMetrics: .Default)
        
        /*
setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
shadow, NSShadowAttributeName,
[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];*/
        
        dropDownMenu.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        shirtView.image = shirt
     
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menus.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = dropDownMenu.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel!.text = self.menus[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.row) {
        case 0:
            self.performSegueWithIdentifier("goto_load", sender: self)
        case 1:
            self.performSegueWithIdentifier("goto_combine", sender: self)
        case 2:
            self.performSegueWithIdentifier("goto_share", sender: self)
        case 3:
            println("selected")
            shirtView.image = nil
        default: ()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    @IBAction func menuButtonTapped(sender: UIBarButtonItem?) {
        if (dropDownMenu.hidden) {
            self.showDropDownView()
        } else {
            
            self.hideDropDownView()
        }
    }
    
    func hideDropDownView() {
        var frame:CGRect = self.dropDownMenu.frame
        //frame.origin.y = -frame.size.height
        dropDownMenu.hidden = true
        //self.animateDropDownToFrame(frame) {}
    }
    
    func showDropDownView() {
        var frame:CGRect = self.dropDownMenu.frame
        //frame.origin.y = self.navigateBar.frame.size.height
        dropDownMenu.hidden = false
       // self.animateDropDownToFrame(frame) {}
        
    }


    
}

