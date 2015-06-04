//
//  SettingModelVC.swift
//  webapp
//
//  Created by Timeless on 03/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class SettingModelVC: UIViewController {
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
    
    @IBOutlet weak var FemaleButt: UIButton!
    @IBOutlet weak var MaleButt: UIButton!
    @IBOutlet weak var txtHeight:
        UITextField!
    @IBOutlet weak var txtWeight:
        UITextField!
    @IBOutlet weak var SkinColourSlider: UISlider!
    
    
    @IBAction func MaleTapped(sender: UIButton) {
        maleUser = true
        selectGender(sender)
        deselectGender(FemaleButt)
    }
    
    @IBAction func FemaleTapped(sender: UIButton) {
        maleUser = false
        selectGender(sender)
        deselectGender(MaleButt)
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
    
    
    @IBAction func SaveModelTapped(sender: UIButton) {
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
        // goto_room
    }
    
    func processAlert(alert: UIAlertAction!) {
        // use default values of height and weight
        height = heightInit
        weight = weightInit
        postToDB()
        self.performSegueWithIdentifier("goto_room", sender: self)
    }
    
    func processConfirmAlert(alert: UIAlertAction!) {
        postToDB()
        self.performSegueWithIdentifier("goto_room", sender: self)
    }
    
    
    func postToDB() {
        // post user information to database
        var info = [maleUser, height, weight, skinColour]
        var client:TCPClient = TCPClient(addr: "146.169.53.36", port: 1111)
        var (success,errmsg)=client.connect(timeout: 10)
        if success{
            println("Connection success!")
            var (success,errmsg)=client.send(str:"SELECT * FROM cities;\n")
            if success{
                println("sent success!")
                                var data=client.read(1024*10)
                if let d = data {
                    if let str = NSString(bytes: d, length: d.count, encoding: NSUTF8StringEncoding) {
                        println("read success")
                        println(str)
                        client.close()
                    }
                }
            }else{
                client.close()
                println(errmsg)
            }
        }else{
            client.close()
            println(errmsg)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
