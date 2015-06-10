//
//  FriendsVC.swift
//  webapp
//
//  Created by Timeless on 10/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class FriendsVC: UIViewController {

    @IBOutlet weak var navigateBar: UINavigationBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButt: UIBarButtonItem!
    
    
    var friends = ["Hubert Yates", "Ricardo Nichols", "Raul Garner", "Wendy Stewart"]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.tableView.editing = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        // change width of navigation bar
        navigateBar.frame=CGRectMake(0, 0, 400, 60)
        
        self.view .addSubview(navigateBar)
        
        navigateBar.setBackgroundImage(UIImage(named:"navigation"),
            forBarMetrics: .Default)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return friends.count
    }

    @IBAction func addButtTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("goto_add", sender: self)
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
