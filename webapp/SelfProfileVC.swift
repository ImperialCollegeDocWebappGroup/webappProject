//
//  SelfProfileVC.swift
//  webapp
//
//  Created by Timeless on 16/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class SelfProfileVC: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    
    
    @IBOutlet weak var userNameLB: UILabel!
    @IBOutlet weak var genderLB: UILabel!
    @IBOutlet weak var heightLB: UILabel!
    @IBOutlet weak var weightLB: UILabel!
    @IBOutlet weak var skinLB: UILabel!
    
    let link : String = "http://www.doc.ic.ac.uk/~jl6613/"
    let fileName : String = "serverIp.txt"
    var serverIp : String = ""
    var dataString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"navigation"), forBarMetrics: .Default)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // Do any additional setup after loading the view.
        var usrInfo = getData()
        userNameLB.text = usrInfo.login
        if  usrInfo.gender {
            genderLB.text = "Male"
        } else{
            genderLB.text = "Female"
        }
        heightLB.text = String(usrInfo.height)
        weightLB.text = String(usrInfo.weight)
        skinLB.text = String(usrInfo.skincolor)
    }
    
    func getData()->UserInfo {
        if postToDB() {
            return parseJson(dataString)
        } else{
            return UserInfo(login: "error",gender:"t",age:"0",height:"0",weight:"0",skincolor:"0")
            // error
        }
    }
    
    func postToDB() -> Bool {
        getServerIp()
        var queryLine = "SELECT login,gender,age,height,weight,skincolour FROM userprofile WHERE login = '"
        println("posting")
        // post user information to database
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let logname =  (prefs.valueForKey("USERNAME") as! NSString as String)
        var requestLine = queryLine + logname + "'\n"
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
                            } else if (dd && str.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0){
                                //data
                                println("this is data")
                                println(str)
                                dataString = str
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
    
    func parseJson(str: NSString)->UserInfo {
        println("===")
        println(str)
        var data: NSData = str.dataUsingEncoding(NSUTF8StringEncoding)!
        var error1: NSError?
        var jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error1)
        if let e  = error1 {
            println("Error: \(error1)")
        }
        let login = (jsonObject as! NSDictionary)["login"] as! [String]
        let gender = (jsonObject as! NSDictionary)["gender"] as! [String]
        let age = (jsonObject as! NSDictionary)["age"] as! [String]
        let height = (jsonObject as! NSDictionary)["height"] as! [String]
        let weight = (jsonObject as! NSDictionary)["weight"] as! [String]
        let skincolor = (jsonObject as! NSDictionary)["skincolour"] as! [String]
        
        
        return UserInfo(login:login[0],gender:gender[0],age:age[0],height:height[0],weight:weight[0],skincolor:skincolor[0])
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
