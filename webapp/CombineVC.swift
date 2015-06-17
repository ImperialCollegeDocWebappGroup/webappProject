//
//  CombineVC.swift
//  webapp
//
//  Created by Timeless on 10/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit


class CombineVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var confirmButt: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    var imgs: [UIImage] = []
    var cloths : [NSString] = []
    let link : String = "http://www.doc.ic.ac.uk/~jl6613/"
    let fileName : String = "serverIp.txt"
    var serverIp : String = ""
    var str2 = ""
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Combine With Another"
        self.tabBarController?.hidesBottomBarWhenPushed
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"navigation"), forBarMetrics: .Default)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        //buttoms
        //hat
        if (postToDB("tops")) {
            
            parseJson(str2)
        }
        
        loadAllImages()
        // Do any additional setup after loading the view.
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
    
    func postToDB(str : String) -> Bool {
        println("posting")
        getServerIp()
        // post user information to database
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let logname =  (prefs.valueForKey("USERNAME") as! NSString as String)
        var requestLine = "SELECT unnest(" + str + ") FROM userprofile WHERE login = '" + logname + "';\n"
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
        getServerIp()
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
        count = length
        cloths = topss
    }
    
    func loadAllImages() {
        for link in cloths {
            if let im = loadSingleImage(link as String) {
              imgs.append(im)
            }
        }
    }
    
    func loadSingleImage(str: String) -> UIImage? {
        if (str as NSString).substringWithRange(NSRange(location: 0, length: 3)) == "picFile" {
            return loadLocalImage(str)
        } else {
            return loadselfridgeImage(str)
        }
    }

    
    func loadLocalImage(str: String) -> UIImage? {
        let url = NSURL(string: str)
        if let data1 = NSData(contentsOfURL: url!) {
            println("!!!!!2")
            return UIImage(data:data1)
            
        }
     return nil
    }
    
    func loadselfridgeImage(str: String) -> UIImage? {
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ImgCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! ImgCell
       // cell.backgroundColor = UIColor.redColor()
        cell.imgView.image = imgs[indexPath.item]
        return cell
    
    }
    
    /*
    
    var largePhotoIndexPath : NSIndexPath? {
        didSet {
            //2
            var indexPaths = [NSIndexPath]()
            if largePhotoIndexPath != nil {
                indexPaths.append(largePhotoIndexPath!)
            }
            if oldValue != nil {
                indexPaths.append(oldValue!)
            }
            //3
            collectionView?.performBatchUpdates({
                self.collectionView?.reloadItemsAtIndexPaths(indexPaths)
                return
                }){
                    completed in
                    //4
                    if self.largePhotoIndexPath != nil {
                        self.collectionView?.scrollToItemAtIndexPath(
                            self.largePhotoIndexPath!,
                            atScrollPosition: .CenteredVertically,
                            animated: true)
                    }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView,
            shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
                if largePhotoIndexPath == indexPath {
                    largePhotoIndexPath = nil
                }
                else {
                    largePhotoIndexPath = indexPath
                }
                return false
    }
    
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            let flickrPhoto = photoForIndexPath(indexPath)
            
            // New code
            if indexPath == largePhotoIndexPath {
                var size = collectionView.bounds.size
                size.height -= topLayoutGuide.length
                size.height -= (sectionInsets.top + sectionInsets.right)
                size.width -= (sectionInsets.left + sectionInsets.right)
                return flickrPhoto.sizeToFillWidthOfSize(size)
            }
            // Previous code
            if var size = flickrPhoto.thumbnail?.size {
                size.width += 10
                size.height += 10
                return size
            }
            return CGSize(width: 100, height: 100)
    }
    */
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "confirmed") {
            let cell = sender as! ImgCell
            var svc = segue.destinationViewController as! MainFeaturesVC;
            svc.shirt = cell.imgView.image

        }
    }
    
    @IBAction func confirmTapped(sender: UIBarButtonItem) {
        var indexPath : NSArray = self.collectionView.indexPathsForSelectedItems()
        self.performSegueWithIdentifier("confirmed", sender: self)
    }
    
}
