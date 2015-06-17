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
    var url: String! = nil
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

        if (url == nil) {
            attachURLButt.hidden = true
        } else {
            attachURLButt.hidden = false
            loadImage()
        }
    }
    

    func loadImage() {
        /*
        var altStringToSearch:String = "I want to make a cake and then prepare coffee"
        let altSearchTerm:String = "cake"
        let altScanner = NSScanner(string: altStringToSearch)
        var altResult:NSString?
        altScanner.scanUpToString(altSearchTerm, intoString:&altResult) // altResult : "I want to make a "
        var len = altResult!.length
        var someString = (altStringToSearch as NSString).substringFromIndex(len)
        println(someString)
        let altSearchTerm2:String = "prepare"
        let altScanner2 = NSScanner(string: someString)
        altScanner.scanUpToString(altSearchTerm2, intoString:&altResult)
        println(altResult!)
        */
        /*
        var realURL: String = "http://www.selfridges.com/en/ralph-lauren-new-fit-bi-swing-windbreaker-jacket_434-88064526-A30J4030Y3177/?previewAttribute=Rl+black"
        */
        
        
        /*original method from loadImageVC
        var error_msg: String = ""
        var invalidURL: Bool = false
        var realURL: String = txtURL.text!
        if let myURL = NSURL(string: realURL) {
            var error: NSError?
            var myHTMLString = NSString(contentsOfURL: myURL, encoding: NSUTF8StringEncoding, error: &error)
            
            if let error = error {
                invalidURL = true
                error_msg = "Your URL is not valid"
                println("Error : \(error)")
            } else {
                // check the url is from selfridges.com
                if realURL.rangeOfString("selfridges") == nil {
                    invalidURL = true
                    error_msg = "URL is not from selfridges.com"
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
                    
                    imageUrl = altResult5! as String
                    loadSuccess = true
                    saveButton.enabled = true
                    imageLink = imageUrl
                }
            }
        } else {
            invalidURL = true
            error_msg = "Invalid URL."
            println("Error: \(realURL) doesn't seem to be a valid URL")
        }
        var image2 : UIImage = UIImage(named:"notfound")!
        let url = NSURL(string: imageUrl)
        if let data = NSData(contentsOfURL: url!) {
            imageURL.image = UIImage(data: data)
            println("good1")
        } else {
            invalidURL = true
        }
        
        if invalidURL {
            println("not good")
            var invalidURLAlert = UIAlertController(title: "Invalid URL", message: error_msg as String, preferredStyle: .Alert )
            
            invalidURLAlert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            
            self.presentViewController(invalidURLAlert, animated: true, completion: nil)
            imageV.image = image2
        }*/
        
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
        textField.text = url
        
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

