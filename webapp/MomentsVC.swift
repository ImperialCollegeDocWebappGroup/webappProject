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
        ["Sam", "Image1", "2015-6-8, 12:20","",""],
        ["Sam2", "Image2", "2015-6-9, 09:30","",""],
        ["Nathan", "Image3", "2015-6-9, 15:13","",""]
    ]
    var str2 : NSString = ""
    
    let link1 : String = "http://www.doc.ic.ac.uk/~jl6613/"
    
    let names : [String] = ["babyicon.jpeg","dengchaoicon.jpg","fanbingbingicon.jpeg","huangxiaomingicon.jpeg","kenzhendongicon.jpg","zhangxinyuicon.jpeg","zhangzhenicon.jpg"]
    
    
    let link : String = "http://www.doc.ic.ac.uk/~jl6613/"
    let fileName : String = "serverIp.txt"
    var serverIp : String = ""
    
    @IBOutlet weak var nav: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let reallink = link + fileName
        let url = NSURL(string: reallink)
        if let data1 = NSData(contentsOfURL: url!) {
            println("!!!!!")
            var datastring = NSString(data:data1, encoding:NSUTF8StringEncoding) as! String
            println(datastring)
            serverIp = datastring
        }
        getMoments()
        self.navigationItem.title = "MOMENTS"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"navigation"), forBarMetrics: .Default)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        
        
    }
    
    
    @IBAction func momentsRefreshTapped(sender: UIBarButtonItem) {
        getMoments()
        self.tableView.reloadData()
    }
    
    func getMoments() {
        getServerIp()
        println("getting moments")
        if postToDB() {
            println("post success")
            parseJson(str2)
        }
    }
    
    func loadImage(str: String) -> UIImage? {
        var error_msg: String = ""
        var invalidURL: Bool = false
        var realURL = str
        var imageURL = ""
        if let myURL = NSURL(string: realURL) {
            var error: NSError?
            var myHTMLString = NSString(contentsOfURL: myURL, encoding: NSUTF8StringEncoding, error: &error)
            if let error = error {
                invalidURL = true
                error_msg = "Your URL is not valid"
                println("Error : \(error)")
                return nil
            } else {
                // check the url is from selfridges.com
                if realURL.rangeOfString("selfridges") == nil {
                    invalidURL = true
                    error_msg = "URL is not from selfridges.com"
                    return nil
                } else {
                    //  println("HTML : \(myHTMLString)")
                    println("success")
                    let altSearchTerm:String = "<div class=\"productImage\">"
                    let altScanner = NSScanner(string: myHTMLString! as String)
                    var altResult:NSString?
                    altScanner.scanUpToString(altSearchTerm, intoString:&altResult)
                    var len2 = altResult!.length
                    // println(len2)
                    var someString = (myHTMLString! as NSString).substringFromIndex(len2)
                    //println(someString)
                    let altSearchTerm2:String = "/>"
                    let altScanner2 = NSScanner(string: someString)
                    var altResult22:NSString?
                    altScanner.scanUpToString(altSearchTerm2, intoString:&altResult22)
                    //   println(altResult22!)
                    let altSearchTerm222:String = "src=\""
                    let altScanner3 = NSScanner(string: altResult22! as String)
                    var altResult5:NSString?
                    altScanner3.scanUpToString(altSearchTerm222, intoString:&altResult5)
                    var len22 = altResult5!.length
                    //println(len22)
                    var someString2 = (altResult22! as NSString).substringFromIndex(len22+5)
                    //println(someString2)
                    let altSearchTerm3:String = "\""
                    let altScanner4 = NSScanner(string: someString2)
                    altScanner4.scanUpToString(altSearchTerm3, intoString:&altResult5)
                    println(altResult5!)
                    imageURL = altResult5! as String
                    
                }
            }
        } else {
            return nil
        }
        let url = NSURL(string: imageURL)
        if let data = NSData(contentsOfURL: url!) {
            return UIImage(data: data)
        } else {
            return nil
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
    
    
    override func viewWillAppear(animated: Bool) {
        println("moments vc appear")
        //refresh data
        super.viewWillAppear(animated);
        
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
        //println(publish[1])
        cell.username.text = publish[0]
        cell.content.text = publish[1]
        cell.publishTime.text = publish[2]
        //println(publish[4])
       
        let reallink : String = link1 + names[indexPath.row % 7]
        println(reallink)
        let url = NSURL(string: reallink)
        if let data1 = NSData(contentsOfURL: url!) {
            println("!!!!!")
            cell.momentsIcon.contentMode = .ScaleAspectFill
            cell.momentsIcon.image = UIImage(data: data1)
            cell.momentsPhoto.contentMode = .ScaleAspectFit
            if publish[3] != "" {
                let url = NSURL(string: link+publish[3])
                if let data2 = NSData(contentsOfURL: url!) {
                    println("!!!!!2")
                    //cell.momentsPhoto.image = UIImage(data: data2)
                    
                }
            } else {
               // cell.momentsPhoto.image = UIImage(data: data1)
                
            }
            
        }
        if publish[4] != "" {
            println("in")
            if let im = loadImage(publish[4]) {
                println("!!!!!3")
                cell.momentsPhoto.image = im
                cell.url = publish[4]
            }
        }
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //selectedRow = indexPath.row
        //self.performSegueWithIdentifier("gotoprofile", sender: self)
        
    }
    
    func postToDB() -> Bool {
        println("posting")
        // post user information to database
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let logname =  (prefs.valueForKey("USERNAME") as! NSString as String)
        //SELECT unnest(friends) FROM friendlist WHERE uname = 'nathan';
        var requestLine = "SELECT usrname,(unnest(shows)).content,(unnest(shows)).photo,(unnest(shows)).publishtime AS ptime , (unnest(shows)).attachurl FROM publishs WHERE usrname in (SELECT unnest(friends) FROM friendlist WHERE uname = '" + logname + "') ORDER BY ptime DESC LIMIT 20;\n"
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
                            } else if dd  && str.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0  {
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
        let namess = (jsonObject as! NSDictionary)["usrname"] as! [NSString]
        let contentss = (jsonObject as! NSDictionary)["content"] as! [NSString]
        let ptimes = (jsonObject as! NSDictionary)["ptime"] as! [NSString]
        let photo = (jsonObject as! NSDictionary)["photo"] as! [NSString]
        let attachurls = (jsonObject as! NSDictionary)["attachurl"] as! [NSString]
        let length = namess.count
        publishes = [[String]](count: length, repeatedValue: ["","","","",""])
        for i in 0..<length {
            publishes[i] = ["","","","",""]
            publishes[i][0] = namess[i] as String
            publishes[i][1] = contentss[i] as String
            publishes[i][2] = (ptimes[i] as NSString).substringWithRange(NSMakeRange(0, 16))
            publishes[i][3] = ""
            
            println(photo[i])
            var photoStr : String = photo[i] as String
            println("photo=====: " + photoStr)
            if photoStr != "" {
                if photoStr.rangeOfString("picFile") != nil {
                    publishes[i][3] = photoStr
                } else {
                    publishes[i][3] += ("\n Share cloth URL: " + photoStr)
                }
            } else {
                println("xxxx-- " + photoStr)
              publishes[i][3] = ""
            }
            var attach = attachurls[i] as String
            if (attach != "") {
                if (attach.rangeOfString("selfridge") != nil) {
                    publishes[i][4] = attach
                }
            }
            
            
        }
    }
    
    
    
}

