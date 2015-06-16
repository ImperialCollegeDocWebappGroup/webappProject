//
//  ScroolVC.swift
//  webapp
//
//  Created by Timeless on 07/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class ToppingsScrollVC: UIViewController, UIScrollViewDelegate {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    var pageImages: [UIImage?] = []
    var pageViews: [UIImageView?] = []
    
    
    let link1 : String = "http://www.doc.ic.ac.uk/~jl6613/"
    let link : String = "http://www.doc.ic.ac.uk/~jl6613/"
    let fileName : String = "serverIp.txt"
    var serverIp : String = ""
    var str2 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // need to load images from DB
        pageImages = []
        
        let reallink = link + fileName
        let url = NSURL(string: reallink)
        if let data1 = NSData(contentsOfURL: url!) {
            println("!!!!!")
            var datastring = NSString(data:data1, encoding:NSUTF8StringEncoding) as! String
            println(datastring)
            serverIp = datastring
        }
        postToDB()
        parseJson(str2)
        
        let pageCount = pageImages.count
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
        
        loadVisiblePages()
        
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
    
    
    
    func loadPage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        if let pageView = pageViews[page] {
        } else {
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            scrollView.addSubview(newPageView)
            
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of display, do nothing
            return
        }
        
        // Remove a page from the scroll view
        // reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    
    func loadVisiblePages() {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        pageControl.currentPage = page
        
        let firstPage = page - 1
        let lastPage = page + 1
        
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        loadVisiblePages()
    }
    
    func postToDB() -> Bool {
        println("posting")
        // post user information to database
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let logname =  (prefs.valueForKey("USERNAME") as! NSString as String)
        var requestLine = "SELECT unnest(tops) FROM userprofile WHERE login = '" + logname + "';\n"
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
        let topss = (jsonObject as! NSDictionary)["unnest"] as! [NSString]
        let length = topss.count
        pageImages = [UIImage?] (count: length, repeatedValue: nil)
        for i in 0..<length {
            println(topss[i])
            pageImages[i] = loadImage(topss[i] as String)
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
    
    
    
    /*
    let scrollView = UIScrollView(frame: CGRectMake(0, 0, 100, 100))
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3, scrollView.frame.size.height)
    scrollView.delegate = self
    let pageControl = UIPageControl(frame:CGRectMake(0, 90, scrollView.frame.size.width, 20))
    pageControl.numberOfPages = Int(scrollView.contentSize.width / scrollView.frame.size.width)
    pageControl.addTarget(self, action: Selector("changePage:"), forControlEvents: UIControlEvents.ValueChanged)
    
    
    func changePage(sender: AnyObject) -> () {
    let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
    scrollView.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) -> () {
    let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width);
    pageControl.currentPage = Int(pageNumber)
    }
    
    
    func changePage(sender: AnyObject) -> () {
    if let page = sender.currentPage {
    var frame:CGRect = scrollView.frame;
    
    frame.origin.x = frame.size.width * CGFloat(page)
    frame.origin.y = 0
    scrollView.scrollRectToVisible(frame, animated: true)
    }
    }
    
    */
}
