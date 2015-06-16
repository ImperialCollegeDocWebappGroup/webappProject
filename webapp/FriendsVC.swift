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
    
    var selectedRow: Int = 0
    
    
    var friends : [NSString] = ["Hubert Yates", "Ricardo Nichols", "Raul Garner", "Wendy Stewart"]
    
    var str2 : NSString = ""
    
    let link1 : String = "http://www.doc.ic.ac.uk/~jl6613/"
    
    let names : [String] = ["babyicon.jpeg","dengchaoicon.jpg","fanbingbingicon.jpeg","huangxiaomingicon.jpeg","kenzhendongicon.jpg","zhangxinyuicon.jpeg","zhangzhenicon.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Friendcell")
        self.navigationItem.title = "FRIENDS"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"navigation"), forBarMetrics: .Default)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
         postToDB()
        // parseJson(str2)


        
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
        cell.textLabel!.text = self.friends[indexPath.row] as String
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        let reallink : String = link1 + names[indexPath.row % 7]
        println(reallink)
        let url = NSURL(string: reallink)
        if let data1 = NSData(contentsOfURL: url!) {
            println("!!!!!")
   
           cell.imageView!.contentMode = .ScaleAspectFit
           cell.imageView!.image = UIImage(data: data1)
                    }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath.row
        self.performSegueWithIdentifier("gotoprofile", sender: self)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "gotoprofile") {
            
            var dvc = segue.destinationViewController as! FriendProfile
            // println(friends[selectedRow])
            dvc.name = friends[selectedRow] as String
            dvc.iconUrl = link1 + names[selectedRow % 7]

        }
      
        
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
    
    func postToDB() -> Bool {
        // post user information to database
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let logname =  (prefs.valueForKey("USERNAME") as! NSString as String)
        
        //SELECT unnest(friends) FROM friendlist WHERE uname = 'nathan';
        
        
        var requestLine = "SELECT unnest(friends) FROM friendlist WHERE uname = '" + logname + "'\n;"
        
        println(requestLine)
        
        var client:TCPClient = TCPClient(addr: "146.169.53.33", port: 1111)
        var (success,errmsg)=client.connect(timeout: 10)
        if success{
            println("Connection success!")
            var (success,errmsg)=client.send(str: requestLine)
            if success {
                println("sent success!")
                var data=client.read(1024*10)
                if let d = data {
                    if let str = NSString(bytes: d, length: d.count, encoding: NSUTF8StringEncoding) {
                        println("read success")
                        println(str)
                        println("fasa4")
                        if (str == "ERROR") {
                            client.close()
                            return false
                        } else {
                            var data=client.read(1024*10)
                            if let d = data {
                                if let str = NSString(bytes: d, length: d.count, encoding: NSUTF8StringEncoding) {
                                    println(str)
                                    str2 = str
                                    println("fasa3")
                                }
                            }
                            return true
                        }
                        
                    }
                }
            }else{
                client.close()
                println(errmsg)
                return false
            }
        }else{
            client.close()
            println(errmsg)
            return false
        }
        return false
    }
    
    func parseJson(str: NSString) {
        println("===")

         println(str)
        var arr = str.componentsSeparatedByString("\n")
        println(arr[1])
        println(arr[0])
        println("===")
        var str2 : NSString = arr[1] as! NSString
        var data: NSData = str2.dataUsingEncoding(NSUTF8StringEncoding)!
        var error1: NSError?
        var jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error1)
        if let e  = error1 {
            println("Error: \(error1)")
        }
        let frds = (jsonObject as! NSDictionary)["unnest"] as! [NSString]
        for element in frds {
            //println(element)
        }
        friends = frds
    }
}