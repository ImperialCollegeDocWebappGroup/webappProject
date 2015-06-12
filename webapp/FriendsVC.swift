//
//  FriendsVC.swift
//  webapp
//
//  Created by Timeless on 10/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class FriendsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var friends = ["Hubert Yates", "Ricardo Nichols", "Raul Garner", "Wendy Stewart"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Friendcell")
        self.navigationItem.title = "Friends"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"navigation4"), forBarMetrics: .Default)

        
    }
    
    
    /*
    override func viewDidAppear(animated: Bool) {
    // 1
    var nav = self.navigationController?.navigationBar
    // 2
    nav?.barStyle = UIBarStyle.Black
    nav?.tintColor = UIColor.yellowColor()
    // 3
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    imageView.contentMode = .ScaleAspectFit
    // 4
    let image = UIImage(named: "black1")
    imageView.image = image
    // 5
    navigationItem.titleView = imageView
    }
    
    */
    
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
        return self.friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("FriendCell") as! UITableViewCell
        
        // Configure the cell...
        cell.textLabel!.text = self.friends[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("gotoprofile", sender: self)    
    
    }
    
    
    /*
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    */

    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    /*
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        let movedObject = self.friends[fromIndexPath.row]
        friends.removeAtIndex(fromIndexPath.row)
        friends.insert(movedObject, atIndex: toIndexPath.row)
        NSLog("%@", "\(fromIndexPath.row) => \(toIndexPath.row) \(friends)")
    }
 */
}
