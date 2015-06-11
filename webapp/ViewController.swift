//
//  ViewController.swift
//  webapp
//
//  Created by Shan, Jinyi on 25/05/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    
    var serverIp  = "146.169.53.36"
    var portNumber = 1111
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterButton.layer.cornerRadius = 5
        logoutButton.layer.cornerRadius = 5
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.blackColor()]
        
        
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
    
    func postdata() {
        //let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        //println (prefs.valueForKey("USERNAME") as! NSString as String)
        var client:TCPClient = TCPClient(addr: "146.169.53.36", port: 1111)
        var (csuccess,cerrmsg)=client.connect(timeout: 10)
        if csuccess{
            println("Connection success!")
            var (ssuccess,serrmsg)=client.send(str: "Hey!\n")
            if ssuccess{
                println("sent success!")
                var data = client.read(1024*10)
                if let d = data {
                    if let str = NSString(bytes: d, length: d.count, encoding: NSUTF8StringEncoding) {
                        println("read success")
                        println(str)
                        var data: NSData = str.dataUsingEncoding(NSUTF8StringEncoding)!
                        var error1: NSError?
                        var jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error1)
                        if let e  = error1 {
                            println("Error: \(error1)")
                        }
                        let c = (jsonObject as! NSDictionary)["content"] as! [String]
                        let u = (jsonObject as! NSDictionary)["usrname"] as! [String]
                        let p = (jsonObject as! NSDictionary)["ptime"] as! [String]
                        println("u: \(u[0])")
                        println("c: \(c[0])")
                        println("p: \(p[0])")
                        client.close()
                    }
                }
            } else {
                println("sent failed!")
                client.close()
                println(serrmsg)
            }
        }else{
            println("connection failed!")
            client.close()
            println(cerrmsg)
        }
    }
    
    
    
    
}

