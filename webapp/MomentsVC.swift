//
//  MomentsVC.swift
//  webapp
//
//  Created by Timeless on 08/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class MomentsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    //var usernames = ["Sam", "Sam2", "Nathan"]
    
    //var contents = ["image1", "image2", "image3"]
    
   // var publishTime = ["2015-6-8, 12:20", "2015-6-9, 09:30", "2015-6-9, 15:13"]
    var publishes = [
        ["Sam", "Image1", "2015-6-8, 12:20"],
        ["Sam2", "Image2", "2015-6-9, 09:30"],
        ["Nathan", "Image3", "2015-6-9, 15:13"]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
    self.navigationItem.title = "Moments"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
    
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"navigation3"), forBarMetrics: .Default)
    

    }
    
    /*
    override func viewDidAppear(animated: Bool) {
        // change width of navigation bar
        navigateBar.frame=CGRectMake(0, 0, 400, 60)
        
        self.view .addSubview(navigateBar)
        
        navigateBar.setBackgroundImage(UIImage(named:"navigation"),
            forBarMetrics: .Default)
    }
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.publishes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MomentCell", forIndexPath: indexPath) as! MomentCell
        
        // Configure the cell...
        let publish = publishes[indexPath.row]
     println(publish[1])
        cell.username.text = publish[0]
        cell.content.text = publish[1]
        cell.publishTime.text = publish[2]
        
        return cell
    }

}
