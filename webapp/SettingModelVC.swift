//
//  SettingModelVC.swift
//  webapp
//
//  Created by Timeless on 03/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class SettingModelVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let heightMin = 120
    let heightMax = 220
    let weightMin = 30
    let weightMax = 200
    let heightInit = 160
    let weightInit = 50
    
    // input values
    var maleUser: Bool = true
    var skinColour: Int = 0
    var height: Int = 160
    var weight: Int = 50
    
    var imagePicker: UIImagePickerController!
    
    var modelImage: UIImage = UIImage(named: "defaultM")!
    
    // false if user just registered, and setting for the 1st time
    var resetModel: Bool = false
    
    @IBOutlet weak var cameraButt: UIButton!
    @IBOutlet weak var FemaleButt: UIButton!
    @IBOutlet weak var MaleButt: UIButton!
    @IBOutlet weak var txtHeight:
    UITextField!
    @IBOutlet weak var txtWeight:
    UITextField!
    @IBOutlet weak var SkinColourSlider: UISlider!
    
    @IBOutlet weak var saveButt: UIButton!
    
    @IBOutlet weak var faceview: UIImageView!
    
    let link : String = "http://www.doc.ic.ac.uk/~jl6613/"
    
    let fileName :  String = "serverIp.txt"
    var serverIp : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Set My Model"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        // ???????????
        //self.navigationController?.navigationBarHidden = true
        
        /* if let previousVC = backViewController {
        if previousVC
        -------> distinguish previous view controller, to hide back button when pushed from registerVC
        }*/
        
        
        if (self.navigationController != nil) {
            // pushed
            resetModel = true
        } else {
            resetModel = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var backViewController : UIViewController? {
        
        var stack = self.navigationController!.viewControllers as Array
        
        for (var i = stack.count-1 ; i > 0; --i) {
            if (stack[i] as! UIViewController == self) {
                return stack[i-1] as? UIViewController
            }
            
        }
        return nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        println("saved")
        if segue.identifier == "saved" {
            println(segue.destinationViewController.description)
            println(segue.sourceViewController.description)
            println(segue.identifier)
            //var svc = segue.destinationViewController as! MainFeaturesVC;
            //svc.shirt = modelImage
        }
    }
    
    @IBAction func MaleTapped(sender: UIButton) {
        maleUser = true
        selectGender(sender)
        deselectGender(FemaleButt)
        modelImage = UIImage(named: "defaultM")!
        
        
    }
    
    @IBAction func FemaleTapped(sender: UIButton) {
        maleUser = false
        selectGender(sender)
        deselectGender(MaleButt)
        modelImage = UIImage(named: "defaultF")!
        
    }
    
    
    func selectGender(butt: UIButton) {
        butt.selected = true
        if butt == MaleButt {
            butt.setImage(UIImage(named: "colour1"), forState: .Selected)
        } else {
            butt.setImage(UIImage(named: "colour2"),
                forState: .Selected)
        }
    }
    
    func deselectGender(butt: UIButton) {
        butt.selected = false
        if butt == MaleButt {
            butt.setImage(UIImage(named: "black1"), forState: .Normal)
        } else {
            butt.setImage(UIImage(named: "black2"),
                forState: .Normal)
        }
    }
    
    
    @IBAction func skinColourChanged(sender: UISlider) {
        skinColour = Int(sender.value)
    }
    
    @IBAction func cameraTapped(sender: UIButton) {
        /*     if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.mediaTypes = [kUTTypeImage as NSString]
        imagePicker.allowsEditing = false
        
        self.presentedViewController(imagePicker, animated:true, completion: nil)
        
        newMedia = true
        }*/
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        println("resetModel is \(resetModel)")
        // check height and weight value
        let a:Int? = txtHeight.text.toInt()
        let b:Int? = txtWeight.text.toInt()
        
        var error_msg:NSString = " "
        var invalidInput: Bool = false
        
        if a != nil && b != nil {
            height = a!
            weight = b!
            if height < heightMin || height > heightMax {
                invalidInput = true
                error_msg = "Invalid height, use default value?"
            } else if weight < weightMin || weight > weightMax {
                invalidInput = true
                error_msg = "Invalid weight, use default value?"
            }
        } else {
            invalidInput = true
            error_msg = "Input values are not all integers, use default value?"
        }
        
        if invalidInput {
            var invalidInputAlert = UIAlertController(title: "Invalid inputs", message: error_msg as String, preferredStyle: .Alert )
            invalidInputAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: processAlert))
            invalidInputAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(invalidInputAlert, animated: true, completion: nil)
        } else {
            var confirmAlert = UIAlertController(title: "Valid inputs", message: "Do you confirm your information?", preferredStyle: .Alert )
            confirmAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: processConfirmAlert))
            confirmAlert.addAction(UIAlertAction(title: "Wait a sec", style: .Cancel, handler: nil))
            self.presentViewController(confirmAlert, animated: true, completion: nil)
        }
        
        
    }
    func processAlert(alert: UIAlertAction!) {
        // use default values of height and weight
        height = heightInit
        weight = weightInit
        if (postToDB()) {
            if (resetModel) {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.performSegueWithIdentifier("saved", sender: self)
            }
        } else {
            var nerworkErrorAlert = UIAlertController(title: "Network error", message: "Network error, please try again", preferredStyle: .Alert )
            nerworkErrorAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(nerworkErrorAlert, animated: true, completion: nil)
        }
        // navigationController?.popViewControllerAnimated(true)
    }
    
    func processConfirmAlert(alert: UIAlertAction!) {
        if (postToDB()) {
            if (resetModel) {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.performSegueWithIdentifier("saved", sender: self)
            }
        } else {
            var nerworkErrorAlert = UIAlertController(title: "Network error", message: "Network error, please try again", preferredStyle: .Alert )
            nerworkErrorAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(nerworkErrorAlert, animated: true, completion: nil)
        }
        //navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    func postToDB() -> Bool {
        getServerIp()
        // post user information to database
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let logname =  (prefs.valueForKey("USERNAME") as! NSString as String)
        var gender = "false"
        if (maleUser) {
            gender = "true"
        }
        var info = [gender, String(height), String(weight), String(skinColour)]
        if resetModel { // reset
            var requestLine = "UPDATE userprofile SET gender = " + info[0] + ", height = " + info[1] + ", weight = " + info[2] + ", skincolour = " + info[3] + " WHERE login = '" + logname + "';\n"
                        if query(requestLine) {
                                       return true
                    }
        } else { // insert
            var requestLine = ("INSERT INTO userprofile VALUES ('" + logname + "', '")
            requestLine += (logname + "', " + info[0] + ", 20, " + info[1] + ", ")
            requestLine += (info[2] + ", " + info[3] + ", ARRAY[]::text[], ARRAY['http://www.selfridges.com/en/givenchy-amerika-cuban-fit-cotton-jersey-t-shirt_242-3000831-15S73176511/?previewAttribute=Black'],")
            var s1 = requestLine + "'',ARRAY[]::text[]);\n"
            //   after new user
            var s2 =    "INSERT INTO publishs VALUES ('" + logname + "',ARRAY[]::publishitem[]);\n"
            var s3 =   "INSERT INTO friendlist VALUES ('" + logname + "',ARRAY['" + logname + "']);\n"
            if query(s1) {
                if query(s2) {
                    if query(s3) {
                        return true
                    }
                }
            }
        }
        
        return false
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
    
    func query(query : String) -> Bool {
        println("posting")
        // post user information to database
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let logname =  (prefs.valueForKey("USERNAME") as! NSString as String)
        var client:TCPClient = TCPClient(addr: serverIp, port: 1111)
        var (success,errmsg)=client.connect(timeout: 10)
        if success{
            println("Connection success!")
            var (success,errmsg)=client.send(str: query)
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
                            } else if dd && str.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
                                //data
                                println("this is data")
                                println(str)
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
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    
}
