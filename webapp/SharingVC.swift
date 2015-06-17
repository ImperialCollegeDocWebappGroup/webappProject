//
//  SharingVC.swift
//  webapp
//
//  Created by Timeless on 08/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class SharingVC: UIViewController {
    var link : NSString = ""
    var selfridgeLink = "http://www.selfridges.com/en/givenchy-17-cotton-baseball-shirt_242-3000831-15S60233001/?previewAttribute=Black"
    
    let pathlink : String = "http://www.doc.ic.ac.uk/~jl6613/"
    let fileName : String = "serverIp.txt"
    var serverIp : String = ""
    var imageString = ""
    var im: UIImage! = nil
    var imgURL: String! = nil
    var webURL: String! = nil
    //var imm : UIImage = UIImage(named: "collect")!
    
    @IBOutlet weak var attachURLButt: UIButton!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // imageV.image = imm
        getServerIp()
        self.navigationItem.title = "Share to Friends"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"navigation"), forBarMetrics: .Default)

        if (webURL == nil) {
            attachURLButt.hidden = true
        } else {
            attachURLButt.hidden = false
            loadImage()
        }
    }
    

    func loadImage() {
        
                    let url = NSURL(string: imgURL)
                    if let data1 = NSData(contentsOfURL: url!) {
                        println("!!!!!2")
                        imageV.image = UIImage(data:data1)
                    }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func share(sender: UIBarButtonItem) {
        processImage()
        query3(selfridgeLink)
       // qq(selfridgeLink)
       // if query1("") {
         //   if query2() {
               // qq(imageString)
           //     println("SUCCESS!!!")
            //}
       // }
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func processImage() {
        
        
        var image = imageV.image
        
        if let realimage = image {
            var imageData = UIImageJPEGRepresentation(realimage,1)
            
            var teststring = imageData.base64EncodedStringWithOptions(nil)
            //println(teststring)
            imageString = teststring
        }
    }
    
    
    @IBAction func attachURL(sender: UIButton) {
        attachURLButt.setTitle("Attached", forState: .Normal)
        
        // post url to DB
    }
    
    func qq(query : String) -> Bool {
        println("posting")
        // post user information to database
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let logname =  (prefs.valueForKey("USERNAME") as! NSString as String)
        println(logname)
        var client:TCPClient = TCPClient(addr: serverIp, port: 1111)
        var (success,errmsg)=client.connect(timeout: 10)
        if success{
            println("Connection success!")
            var (success,errmsg)=client.send(str: "SP\n")
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
                            if (str == "GOOD") {
                                println("--GOOD")
                                (success,errmsg)=client.send(str: logname+"\n")
                            } else if (str == "GOOD2") {
                                println("--GOOD2")
                                (success,errmsg)=client.send(str: query+"\n")
                            } else if (str == "ERROR") {
                                println("--ERROR")
                                client.close()
                                return false
                            } else if (str == "SAVEANDPUBLISHDONE"){ // NOERROR
                                println("--DONE")
                                client.close()
                                return true
                            } else {
                                if (str.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0) {
                                    println( " er...")
                                    (success,errmsg)=client.send(str:"GOOD\n")
                                }
                                
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
    
    func query3(query : String) -> Bool { // publish text
        println("posting")
        // post user information to database
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let logname =  (prefs.valueForKey("USERNAME") as! NSString as String)
        println(logname)
        var client:TCPClient = TCPClient(addr: serverIp, port: 1111)
        var (success,errmsg)=client.connect(timeout: 10)
        if success{
            println("Connection success!")
            var (success,errmsg)=client.send(str: "PUBLISH\n")
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
                            if (str == "GOOD") {
                                println("--GOOD")
                                (success,errmsg)=client.send(str: logname+"\n")
                            } else if (str == "GOOD2") {
                                println("--GOOD2")
                                println(textField.text)
                                (success,errmsg)=client.send(str: query+"\n")
                            } else if (str == "ERROR") {
                                println("--ERROR")
                                client.close()
                                return false
                            } else if (str == "PUBLISHDONE"){ // NOERROR
                                println("--DONE")
                                client.close()
                                return true
                            } else {
                                if (str.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0) {
                                    println( " er...")
                                    (success,errmsg)=client.send(str: textField.text+"\n")
                                }
                                
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
    
    
    func query1(query : String) -> Bool { // publish text
        println("posting")
        // post user information to database
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let logname =  (prefs.valueForKey("USERNAME") as! NSString as String)
        println(logname)
        var client:TCPClient = TCPClient(addr: serverIp, port: 1111)
        var (success,errmsg)=client.connect(timeout: 10)
        if success{
            println("Connection success!")
            var (success,errmsg)=client.send(str: "PUBLISH\n")
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
                            if (str == "GOOD") {
                                println("--GOOD")
                                (success,errmsg)=client.send(str: logname+"\n")
                            } else if (str == "GOOD2") {
                                println("--GOOD2")
                                println(textField.text)
                                (success,errmsg)=client.send(str: textField.text+"\n")
                            } else if (str == "ERROR") {
                                println("--ERROR")
                                client.close()
                                return false
                            } else if (str == "PUBLISHDONE"){ // NOERROR
                                println("--DONE")
                                client.close()
                                return true
                            } else {
                                if (str.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0) {
                                    println( " er...")
                                    (success,errmsg)=client.send(str: textField.text+"\n")
                                }
                                
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
    
    func query2() -> Bool {
        println("posting")
        // post user information to database
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let logname =  (prefs.valueForKey("USERNAME") as! NSString as String)
        println(logname)
        var client:TCPClient = TCPClient(addr: serverIp, port: 1111)
        var (success,errmsg)=client.connect(timeout: 10)
        if success{
            println("Connection success!")
            var (success,errmsg)=client.send(str: "SAVE1\n")
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
                            if (str == "GOOD") {
                                println("--GOOD")
                                (success,errmsg)=client.send(str: logname+"\n")
                            } else if (str == "GOOD2") {
                                println("--GOOD2")
                                (success,errmsg)=client.send(str: imageString+"\n")
                            } else if (str == "ERROR") {
                                println("--ERROR")
                                client.close()
                                return false
                            } else if (str == "SAVEDONE"){ // NOERROR
                                println("--DONE")
                                client.close()
                                return true
                            } else {
                                if (str.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0) {
                                    println( " er...")
                                    (success,errmsg)=client.send(str:"GOOD\n")
                                }
                                
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
    
    
    
    func getServerIp() {
        let reallink = pathlink + fileName
        let url = NSURL(string: reallink)
        if let data1 = NSData(contentsOfURL: url!) {
            println("!!!!!")
            var datastring = NSString(data:data1, encoding:NSUTF8StringEncoding) as! String
            println(datastring)
            serverIp = datastring
        }
    }
    
}

