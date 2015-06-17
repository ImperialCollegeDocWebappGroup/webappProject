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
    

    let link: String = "http://www.doc.ic.ac.uk/~jl6613/"
    let fileName : String = "serverIp.txt"
    var serverIp : String = ""
    
    let names : [String] = ["babyicon.jpeg","dengchaoicon.jpg","fanbingbingicon.jpeg","huangxiaomingicon.jpeg","kenzhendongicon.jpg","zhangxinyuicon.jpeg","zhangzhenicon.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Friendcell")
        self.navigationItem.title = "FRIENDS"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"navigation"), forBarMetrics: .Default)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let reallink = link + fileName
        let url = NSURL(string: reallink)
        if let data1 = NSData(contentsOfURL:url!) {
            println("!!!!!")
            var datastring = NSString(data:data1, encoding:NSUTF8StringEncoding) as! String
            println(datastring)
            serverIp = datastring
        }
        getFriends()
    }
    
    
    @IBAction func refreshTapped(sender: UIBarButtonItem) {
        getFriends()
        self.tableView.reloadData()
    }
    
    func getFriends() {
        println("getting")
        if postToDB() {
            println("post success")
            parseJson(str2)
        }
    }
    
    func getServerIp() {
        let reallink = link + fileName
        let url = NSURL(string: reallink)
        if let data1 = NSData(contentsOfURL: url!) {
            println("!!!!!")
            var datastring = NSString(data:data1, encoding:NSUTF8StringEncoding) as! String
            println(datastring)
            serverIp = datastring
        }
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

        } else if (segue.identifier == "addFriends") {
            getFriends()
            var dvc = segue.destinationViewController as! AddNewFriend
            dvc.friendsList = friends
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        //println("friends vc appear")
        //  getFriends()
        super.viewWillAppear(animated);
    }
    
    
    func postToDB() -> Bool {
        println("posting")
        // post user information to database
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let logname =  (prefs.valueForKey("USERNAME") as! NSString as String)
        //SELECT unnest(friends) FROM friendlist WHERE uname = 'nathan';
        var requestLine = "SELECT unnest(friends) FROM friendlist WHERE uname = '" + logname + "';\n"
        println(requestLine)
        var client:TCPClient = TCPClient(addr: serverIp, port: 1111)
        var (success,errmsg)=client.connect(timeout: 10)
        if success{
            println("Connection success!")
            var (success,errmsg)=client.send(str: requestLine)
            var i: Int = 0
            var dd : Bool = false
            while true {
                if success && i < 10 {
                    println("sent success!")
                    var data=client.read(1024*10)
                    if let d = data {
                        if let str1 = NSString(bytes: d, length: d.count, encoding: NSUTF8StringEncoding) {
                            println("read success")
                            println(str1)
                            println("----")
                            var str  = str1.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                            println(str)
                            //println("fasa4")
                            if (str == "ERROR") {
                                println("--ERROR")
                                client.close()
                                return false
                            } else if (str == "NOERROR"){ // NOERROR
                                println("--NOERROR")
                                (success,errmsg)=client.send(str: "GOOD\n")
                            } else if (str == "NOR") {
                                println("--NOR")
                                client.close()
                                return true
                            } else if (str == "YESR") {
                                println("--YESR")
                                dd = true
                                (success,errmsg)=client.send(str: "GOOD\n")
                            } else if dd && str.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0{
                                //data
                                println("this is data")
                                println(str)
                                str2 = str
                                return true
                            } else {
                                println("er...")
                                (success,errmsg)=client.send(str: "GOOD\n")
                            }
                        }
                        
                    }
                    i+=1
                    
                } else {
                    client.close()
                    println(errmsg)
                    return false
                }
                
            }
        }else{
            client.close()
            println(errmsg)
            return false
        }
    }
    
                    
    func parseJson(str: NSString) {
        println("===")
        println(str)
        var data: NSData = str.dataUsingEncoding(NSUTF8StringEncoding)!
        var error1: NSError?
        var jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error1)
        if let e  = error1 {
            println("Error: \(error1)")
        }
        let frds = (jsonObject as! NSDictionary)["unnest"] as! [NSString]
        let length = frds.count
        friends = [NSString](count: length, repeatedValue: "")
        //for element in frds {
            //println(element)
        //}
        friends = frds
    }
}