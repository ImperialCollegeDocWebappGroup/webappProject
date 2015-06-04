//
//  LoadImageVC.swift
//  webapp
//
//  Created by Timeless on 03/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class LoadImageVC: UIViewController {

    var imageUrl: String = "www.google.co.uk"
    
    @IBOutlet weak var txtURL: UITextField!
    
    @IBOutlet weak var imageURL: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func buttonPressed(sender: UIButton) {
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
                }
            }
        } else {
            invalidURL = true
            error_msg = "Invalid URL."
            println("Error: \(realURL) doesn't seem to be a valid URL")
        }
        /*
        NSString *url = nil;
        NSString *htmlString = ...
        NSScanner *theScanner = [NSScanner scannerWithString:htmlString];
        // find start of IMG tag
        [theScanner scanUpToString:@"<img" intoString:nil];
        if (![theScanner isAtEnd]) {
        [theScanner scanUpToString:@"src" intoString:nil];
        NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
        [theScanner scanUpToCharactersFromSet:charset intoString:nil];
        [theScanner scanCharactersFromSet:charset intoString:nil];
        [theScanner scanUpToCharactersFromSet:charset intoString:&url];
        // "url" now contains the URL of the img
        }
        */
        
        var image2 : UIImage = UIImage(named:"notfound")!
        let url = NSURL(string: imageUrl)
        if let data = NSData(contentsOfURL: url!) {
            imageURL.image = UIImage(data: data)
        } else {
            invalidURL = true
        }
        
        if invalidURL {
            var invalidURLAlert = UIAlertController(title: "Invalid URL", message: error_msg as String, preferredStyle: .Alert )
            
            invalidURLAlert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            
            self.presentViewController(invalidURLAlert, animated: true, completion: nil)
            imageURL.image = image2
        }
    }
    
   /* @IBAction func displayImage(sender: UIButton) {
        var image2 : UIImage = UIImage(named:"notfound")!
        let url = NSURL(string: imageUrl)
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        if data != nil {
            
            // imageURL.image = UIImage(data: data!)
            imageURL.image = image2
        }
        
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
