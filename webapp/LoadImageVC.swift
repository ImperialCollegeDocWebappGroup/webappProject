//
//  LoadImageVC.swift
//  webapp
//
//  Created by Timeless on 03/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class LoadImageVC: UIViewController {
    
    
    @IBOutlet weak var selectTable: UITableView!
    
    var items:[String] = ["Top", "Bottom", "Hat"]
    
    var imgs:[String] = ["ttop","bbottom","hhat"]
    var selectParts = 0
    
    var loadSuccess: Bool = false
    var imageUrl: String = "www.google.co.uk"
    var imageLink = ""
    var realURL: String = ""
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var txtURL: UITextField!
    
    @IBOutlet weak var imageURL: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectTable.hidden = true
        selectTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        saveButton.enabled = false
        //self.hidesBottomBarWhenPushed = true
        self.navigationItem.title = "Load Image"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"navigation"), forBarMetrics: .Default)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        imageURL.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTapped(sender: UIBarButtonItem) {
        if (selectTable.hidden) {
            self.showDropDownView()
        } else {
            self.hideDropDownView()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = selectTable.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        cell.imageView?.image = UIImage(named: imgs[indexPath.row])
        
        return cell
    }
    
    
    
    func hideDropDownView() {
        var frame:CGRect = self.selectTable.frame
        frame.origin.y = -frame.size.height
        selectTable.hidden = true
        //self.animateDropDownToFrame(frame) {}
    }
    
    func showDropDownView() {
        var frame:CGRect = selectTable.frame
        frame.origin.y = self.navigationController!.navigationBar.frame.size.height + 5
        selectTable.hidden = false
        // self.animateDropDownToFrame(frame) {}
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectTable.hidden = true
        selectParts = indexPath.row
        switch (indexPath.row) {
        case 0:
            // top
            //println("top")
            self.performSegueWithIdentifier("save", sender: self)
        case 1:
            // bottom
            println("bottom")
            self.performSegueWithIdentifier("save", sender: self)
        case 2:
            // other
            println("other")
            self.performSegueWithIdentifier("save", sender: self)
        default: ()
        }
    }
    
    
    @IBAction func buttonPressed(sender: UIButton) {
        imageURL.hidden = false
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
        var error_msg: String = ""
        var invalidURL: Bool = false
        realURL = txtURL.text!
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
            imageURL.image = image2
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        println("called")
        println(segue.destinationViewController.description)
        println(segue.sourceViewController.description)
        println(segue.identifier)
        var svc = segue.destinationViewController as! MainFeaturesVC;
        
        svc.shirt = imageURL.image
        
        svc.selectParts = selectParts
        svc.imageLink = imageLink
        svc.imgURL = imageUrl
        svc.webURL = realURL
        //println("url is \(imageUrl)")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
}
