//
//  MainFeaturesVC.swift
//  webapp
//
//  Created by Timeless on 03/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class MainFeaturesVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var sectionMenu: UITableView!
    
    @IBOutlet weak var menuButt: UIBarButtonItem!
    
    @IBOutlet weak var dropDownMenu: UITableView!
    
    @IBOutlet weak var modelView: UIImageView!
    
    @IBOutlet weak var shirtView: UIImageView!
    
    @IBOutlet weak var bottomView: UIImageView!
    
    //var currentView: UIImageView! = nil
    
    
    var shirt: UIImage! = nil
    var bottom: UIImage! = nil
    
    var imgURL: String! = nil
    var webURL: String! = nil
    
    var menus:[String] = ["Load Clothing", "Combine with another", "Add to my wardrobe", "Share to Friends", "Clear Appearance"]
    var sections:[String] = ["Top", "Bottom", "Hat", "Whole"]
    var sectionImgs:[String] = ["ttop", "bbottom", "hhat", "appearance"]
    let link : String = "http://www.doc.ic.ac.uk/~jl6613/"
    let fileName : String = "serverIp.txt"
    var serverIp : String = ""
    var str2 = ""
    var imageLink = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*if(selectParts == 0)
        {
            currentView = shirtView
        }else{
            currentView = bottomView
        }*/

        
        let reallink = link + fileName
        let url = NSURL(string: reallink)
        if let data1 = NSData(contentsOfURL: url!) {
            println("!!!!!")
            var datastring = NSString(data:data1, encoding:NSUTF8StringEncoding) as! String
            println(datastring)
            serverIp = datastring
        }
        
        
        dropDownMenu.hidden = true
        sectionMenu.hidden = true
        self.navigationItem.title = "FITTING ROOM"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"navigation"), forBarMetrics: .Default)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        
        
        shirtView.userInteractionEnabled = true
        /*
        setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
        [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
        shadow, NSShadowAttributeName,
        [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];*/
        
        dropDownMenu.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        sectionMenu.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell2")
        
        shirtView.image = shirt
        if(shirtView.image != nil){
            process()
        }
        
        
        var usrInfo = getData()
        
        if(usrInfo.gender){
            modelView.image = UIImage(named:"defaultM")
        }else{
            modelView.image = UIImage(named:"defaultF")
        }
        
        
        process_skin()
        
        //change model:
        var default_weight = 50.0
        var default_height = 160.0
        
        var modelHeight = Double(usrInfo.height)
        var modelWidth = Double(usrInfo.weight)
        
        if(modelHeight < 10.0){
            modelHeight = default_height
            
        }
        
        if(modelWidth < 10.0){
            modelWidth = default_weight
        }
        
        var imageStretch = CGFloat(1)//(CGFloat(modelWidth/default_weight) + CGFloat(modelHeight/default_height))/2
        modelView.transform = CGAffineTransformScale(modelView.transform, imageStretch, 1);
        println(imageLink)
        
    }
    
    func getServerIp() {
        let reallink = link + fileName
        let url = NSURL(string: reallink)
        if let data1 = NSData(contentsOfURL: url!) {
            println("getServerIP")
            var datastring = NSString(data:data1, encoding:NSUTF8StringEncoding) as! String
            println(datastring)
            serverIp = datastring
        }
    }
    
    func getData()->UserInfo {
        if postToDB() {
            return parseJson(str2)
        } else{
            return UserInfo(login: "error",gender:"t",age:"0",height:"0",weight:"0",skincolor:"0")
            // error
        }
    }
    
    func postToDB() -> Bool {
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
        
        if (login.count != 0) {
            return UserInfo(login:login[0],gender:gender[0],age:age[0],height:height[0],weight:weight[0],skincolor:skincolor[0])
        }
        return UserInfo(login: "error",gender:"t",age:"0",height:"0",weight:"0",skincolor:"0")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == dropDownMenu) {
            return self.menus.count
        } else {
            return self.sections.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView == dropDownMenu) {
            var cell:UITableViewCell = dropDownMenu.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
            
            cell.textLabel!.text = self.menus[indexPath.row]
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
        } else {
            var cell:UITableViewCell = sectionMenu.dequeueReusableCellWithIdentifier("cell2") as! UITableViewCell
            
           // cell.textLabel!.text = self.sections[indexPath.row]
            //cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            var imageName = UIImage(named: sectionImgs[indexPath.row])
            cell.imageView!.image = imageName
            return cell
            
        }
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        sectionMenu.hidden = true
        var addOrShare = 0
        if (tableView == dropDownMenu) {
            switch (indexPath.row) {
            case 0:
                dropDownMenu.hidden = true
                self.performSegueWithIdentifier("goto_load", sender: self)
            case 1:
                dropDownMenu.hidden = true
                self.performSegueWithIdentifier("goto_combine", sender: self)
            case 2:
                //add to my collection
                sectionMenu.hidden = false
                addOrShare = 2
                
            case 3:
                if (shirtView.image != nil) {
                    sectionMenu.hidden = false
                    addOrShare = 3
                }
            case 4:
                dropDownMenu.hidden = true
                shirtView.image = nil
            default: ()
            }
            dropDownMenu.deselectRowAtIndexPath(indexPath, animated: true)
        }
        if (tableView == sectionMenu) {
            // choose between top, bottom, other and whole appearance
            dropDownMenu.hidden = true
            sectionMenu.hidden = true
            if (addOrShare == 2) {
                // add to my wardrobe
            switch (indexPath.row) {
            case 0:
                // add to top
                println("top")
            case 1:
                // add to bottom
                println("bottom")
            case 2:
                // add to hat
                println("hat")
            case 3:
                // whole appearance
                
                UIGraphicsBeginImageContext(view.frame.size)
                view.layer.renderInContext(UIGraphicsGetCurrentContext())
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                var imageData = UIImageJPEGRepresentation(image,1)
                
                var teststring = imageData.base64EncodedStringWithOptions(nil)
                //println(teststring)
                
                // postToDB(teststring)
                
                println("appearance")
            default: ()
                
            }
            } else {
                // share to friends
                switch (indexPath.row) {
                case 0:
                    // add to top
                    println("top")
                case 1:
                    // add to bottom
                    println("bottom")
                case 2:
                    // add to hat
                    println("hat")
                case 3:
                    // whole appearance
                    
                    UIGraphicsBeginImageContext(view.frame.size)
                    view.layer.renderInContext(UIGraphicsGetCurrentContext())
                    let image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    var imageData = UIImageJPEGRepresentation(image,1)
                    
                    var teststring = imageData.base64EncodedStringWithOptions(nil)
                    //println(teststring)
                    
                    // postToDB(teststring)
                    
                    println("appearance")
                default: ()
                }
             self.performSegueWithIdentifier("goto_share", sender: self)
            }
            sectionMenu.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
            if (segue.identifier == "goto_share") {
                var svc = segue.destinationViewController as! SharingVC;
                svc.webURL = webURL
                svc.imgURL = imgURL
                //println("url is \(imageUrl)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func menuButtonTapped(sender: UIBarButtonItem?) {
        if (dropDownMenu.hidden) {
            self.showDropDownView()
        } else {
            self.hideDropDownView()
        }
        if (!sectionMenu.hidden) {
            self.sectionMenu.hidden = true
        }
    }
    
    func hideDropDownView() {
        var frame:CGRect = self.dropDownMenu.frame
        //frame.origin.y = -frame.size.height
        dropDownMenu.hidden = true
        //self.animateDropDownToFrame(frame) {}
    }
    
    func showDropDownView() {
        var frame:CGRect = self.dropDownMenu.frame
        //frame.origin.y = self.navigateBar.frame.size.height
        dropDownMenu.hidden = false
        // self.animateDropDownToFrame(frame) {}
        
    }
    
    
    @IBAction func scaleImage(sender: UIPinchGestureRecognizer) {
        
        shirtView.transform = CGAffineTransformScale(shirtView.transform, sender.scale,sender.scale)
       // println("scaleImage")
        sender.scale = 1
        
    }
    
    
    func postToDB(str2 : String) {
        // post user information to database
        var client:TCPClient = TCPClient(addr: "146.169.53.33", port: 1111)
        var (success,errmsg) = client.connect(timeout: 10)
        if success{
            println("Connection success!")
            var (success,errmsg) = client.send(str: "SAVE\n")
            if success{
                println("sent success 1!")
                (success,errmsg) = client.send(str: str2)
                if success{
                    println("sent success 2!")
                    (success,errmsg) = client.send(str: "\n")
                    if success {
                        println("3")
                    }
                    var data=client.read(1024*10)
                    if let d = data {
                        if let str = NSString(bytes: d, length: d.count, encoding: NSUTF8StringEncoding) {
                            println("read success")
                            println(str)
                            client.close()
                        }
                    }
                } else {
                    client.close()
                    println(errmsg)
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
    
    var location = CGPoint(x:0,y:0)
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            //  location = touch.locationInView(self.view)
            //  shirtView.center = location
        }
        super.touchesBegan(touches , withEvent:event)
        
    }
    
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            location = touch.locationInView(self.view)
            shirtView.center = location
            
        }
        super.touchesBegan(touches , withEvent:event)
        
    }
    
    private func createARGBBitmapContext(inImage: CGImageRef) -> CGContext {
        //Get image width, height
        let pixelsWide = CGImageGetWidth(inImage)
        let pixelsHigh = CGImageGetHeight(inImage)
        // Declare the number of bytes per row. Each pixel in the bitmap in this example is represented by 4 bytes; 8 bits each of red, green, blue, and alpha.
        let bitmapBytesPerRow = Int(pixelsWide) * 4
        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        // Use the generic RGB color space.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // Allocate memory for image data. This is the destination in memory where any drawing to the bitmap context will be rendered.
        let bitmapData = malloc((bitmapByteCount))
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        // Create the bitmap context. We want pre-multiplied ARGB, 8-bits per component. Regardless of what the source image format is (CMYK, Grayscale, and so on) it will be converted over to the format  specified here by CGBitmapContextCreate.
        let context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, (8), (bitmapBytesPerRow), colorSpace, bitmapInfo)
        return context
    }
    
    private func getcolorfrompoint(context:CGContextRef ,rect:CGRect, inImage: CGImage,x:Int, y:Int)-> UIColor{
        var devider: UInt8 = 1
        
        CGContextDrawImage(context, rect, inImage)
        let pixelsWide = CGImageGetWidth(inImage)
        let pixelsHigh = CGImageGetHeight(inImage)
        
        var data = CGBitmapContextGetData(context)
        var dataType = UnsafePointer<UInt8>(data)
        var offset = 4*((Int(pixelsWide) * Int(y)) + Int(x))
        let alphaValue = dataType[offset]
        let redColor = dataType[offset+1]
        let greenColor = dataType[offset+2]
        let blueColor = dataType[offset+3]
        
        let redFloat = CGFloat(redColor)/255.0
        let greenFloat = CGFloat(greenColor)/255.0
        let blueFloat = CGFloat(blueColor)/255.0
        let alphaFloat = CGFloat(alphaValue)/255.0
        return UIColor(red: redFloat, green: greenFloat, blue: blueFloat, alpha: alphaFloat)
    }
    
    private func outrange(i:Int,j:Int,wide:Int,hight:Int)->Bool{
        
        if(selectParts==0 ){
            if((i > (wide*13/30))&&(i < wide*17/30) && (j>(hight/6))&&(j<(hight*45/100))){
                return false
            }
        }else if(selectParts==1){
            if((i > (wide*29/90))&&(i < wide*61/90) && (j>(hight*13/80))&&(j<(hight*85/100)) ){
                return false
            }
        }else if(selectParts==2){
            if((i > (wide*3/90))&&(i < wide*87/90) && (j>(hight*10/80))&&(j<(hight*90/100)) ){
                return false
            }
        }
        return true
        
    }
    
    var selectParts = 0
    
    private func modifyPixel(context:CGContextRef,inImage: CGImage,color:UIColor)->UIImage{
        typealias RawColorType = (newRedColor:UInt8, newgreenColor:UInt8, newblueColor:UInt8, newalphaValue:UInt8)
        let pixelsWide = CGImageGetWidth(inImage)
        let pixelsHigh = CGImageGetHeight(inImage)
        
        var data = CGBitmapContextGetData(context)
        var dataType = UnsafeMutablePointer<UInt8>(data)
        switch selectParts{
        case 0:
            
            for i in 0...pixelsWide{
                var foundBoundry = false
                var lastboundry = 0
                var boundry = 0
                
                for j in 0...pixelsHigh{
                    
                    let offset = 4*((Int(pixelsWide) * Int(j)) + Int(i))
                    if(outrange(i,j:j,wide:pixelsWide,hight:pixelsHigh) && detect_white_background(dataType, offset:offset)){
                        
                        clear_pixel(dataType, offset:offset)
                    }
                    // above remove background
                    
                    if(outrange(i,j:j,wide:pixelsWide,hight:pixelsHigh)){
                        
                        if(j<pixelsHigh/7&&(detect_human_skin(dataType, offset: offset)||detectBlack(dataType,offset:offset))){
                            
                            clear_pixel(dataType, offset:offset)
                            // remove head
                        }else if(detect_human_skin(dataType, offset:offset)){
                            clear_pixel(dataType, offset:offset)
                        }
                    }
                    // above removes human skin
                    
                    
                    if( !foundBoundry && (j > getBoundry(pixelsHigh) )){
                        
                        let offset_above = 4*((Int(pixelsWide) * Int(j-5)) + Int(i))
                        
                        if( detectBoundry(dataType,off1:offset,off2:offset_above) /*&& (i-lastboundry<10 || i-lastboundry>100)*/ ){
                            foundBoundry = true
                            boundry = j
                        }else{
                            // println("didn't find boundry yet")
                            // println(i,j)
                        }
                    }else if(foundBoundry){
                        clear_pixel(dataType, offset: offset)
                    }
                }
            }
            
        case 1:
            
            for i in 0...pixelsWide{
                
                var firstBoundry = 0
                var secondBoundry = 0
                var findFirst  = false
                var findSecond = false
                
                for j in 0...pixelsHigh{
                    
                    let offset = 4*((Int(pixelsWide) * Int(j)) + Int(i))
                    
                    if(outrange(i,j:j,wide:pixelsWide,hight:pixelsHigh)){
                        clear_pixel(dataType, offset:offset)
                    }
                    
                    if(!findFirst && j < pixelsHigh-1 /*&& j<getBoundry(pixelsHigh)*/ ){
                        
                        let offset_above = 4*((Int(pixelsWide) * Int(j+1)) + Int(i))
                        let offset_two_above = 4*((Int(pixelsWide) * Int(j+2)) + Int(i))
                        
                        if(detectBoundry(dataType,off1:offset_above,off2:offset_two_above)){
                            
                            findFirst = true
                            firstBoundry = j
                            //println(firstBoundry)
                            //println(i,j)
                            //clear_pixel(dataType,offset:offset)
                        }
                        clear_pixel(dataType,offset:offset)
                        
                        // clear_pixel(dataType,offset:offset)
                    }
                    
                    if(findFirst && detect_white_background(dataType, offset: offset)){
                        clear_pixel(dataType,offset:offset)
                    }
                    
                    if(findFirst && detect_human_skin(dataType, offset: offset)){
                        clear_pixel(dataType,offset:offset)
                    }
                    
                    
                }
            }
            
            
        case 2:
            for i in 0...pixelsWide{
                for j in 0...pixelsHigh{
                    
                    let offset = 4*((Int(pixelsWide) * Int(j)) + Int(i))
                    
                    if(outrange(i,j:j,wide:pixelsWide,hight:pixelsHigh)){
                        clear_pixel(dataType, offset:offset)
                    }
                    if(detect_white_background(dataType, offset: offset)){
                        clear_pixel(dataType, offset:offset)
                        
                    }
                }
            }
        default:
            ()
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        let bitmapBytesPerRow = Int(pixelsWide) * 4
        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        let finalcontext = CGBitmapContextCreate(data, pixelsWide, pixelsHigh, (8), (bitmapBytesPerRow), colorSpace, bitmapInfo)
        let imageRef = CGBitmapContextCreateImage(finalcontext)
        
        return UIImage(CGImage: imageRef)!
    }
    
    func detect_human_skin(dataType:UnsafeMutablePointer<UInt8>,offset:Int)-> Bool{
        var r = Int(dataType[offset+1])
        var g = Int(dataType[offset+2])
        var b = Int(dataType[offset+3])
        var cond = max(r,g:g,b:b) - min(r,g:g,b:b) > 15
        var cond_rg = diff(dataType[offset+1],b:dataType[offset+2])>15
        if ( (r>95)&&(g>40)&&(b>20)&&cond&&cond_rg&&(r>g)&&(r>b) ){
            return true
        }
        return false
    }
    
    func detectBlack(dataType:UnsafeMutablePointer<UInt8>,offset:Int)-> Bool{
        
        
        var r = Int(dataType[offset+1])
        var g = Int(dataType[offset+2])
        var b = Int(dataType[offset+3])
        
        if( r < 100 && g < 65 && b < 65){
            return true
        }
        
        return false
    }
    func max(r:Int,g:Int,b:Int)->Int{
        var res = r
        if(g > res){
            res = g
        }
        
        if(b > res){
            res = b
        }
        
        return res
        
    }
    
    func min(r:Int,g:Int,b:Int)->Int{
        var res = r
        if(g < res){
            res = g
        }
        
        if(b < res){
            res = b
        }
        
        return res
        
    }
    
    func detect_white_background(dataType:UnsafeMutablePointer<UInt8>,offset:Int)-> Bool{
        if (dataType[offset+1] > 240 && dataType[offset+2] > 240 && dataType[offset+3] > 240){
            return true
        }
        return false
    }
    
    func clear_pixel(dataType:UnsafeMutablePointer<UInt8>,offset:Int){
        dataType[offset]   = 0
        dataType[offset+1] = 0
        dataType[offset+2] = 0
        dataType[offset+3] = 0
    }
    
    func getBoundry(height:Int) -> Int{
        switch selectParts{
        case 0: return height*19/30
        case 1: return height*8/30
        default: return 0
        }
    }
    
    
    func detectBoundry(dataType:UnsafeMutablePointer<UInt8>,off1:Int,off2:Int)->Bool{
        
        var red     = Int(diff(dataType[off1], b:dataType[off2]))
        var green   = Int(diff(dataType[off1+1], b:dataType[off2+1]))
        var blue    = Int(diff(dataType[off1+2], b:dataType[off2+2]))
        var alpha   = Int(diff(dataType[off1+3], b:dataType[off2+3]))
        
        let difference :Int = red+green+blue+alpha
        let thrash :Int = 80
        if( difference > thrash){
            return true
        }else{
            
        }
        
        return false
    }
    
    func diff(a:UInt8, b:UInt8 )->UInt8{
        if(a > b){
            return (a - b)
        }else{
            return (b - a)
        }
    }
    
    private func modifySkin(context:CGContextRef,inImage: CGImage,skin:UInt8)->UIImage{
        typealias RawColorType = (newRedColor:UInt8, newgreenColor:UInt8, newblueColor:UInt8, newalphaValue:UInt8)
        let pixelsWide = CGImageGetWidth(inImage)
        let pixelsHigh = CGImageGetHeight(inImage)
        
        var data = CGBitmapContextGetData(context)
        var dataType = UnsafeMutablePointer<UInt8>(data)
        
        println(pixelsWide,pixelsHigh)
        
        for i in 0...pixelsWide{
            for j in 0...pixelsHigh{
                
                let offset = 4*((Int(pixelsWide) * Int(j)) + Int(i))
                /*dataType[offset+1] = 200
                dataType[offset+2] = 210
                dataType[offset+3] = 210
                */
                
                var r = Int(dataType[offset+1])
                var g = Int(dataType[offset+2])
                var b = Int(dataType[offset+3])
                
                
                if(detect_human_skin(dataType, offset: offset)){
                    //println("what~")
                    r -= 17 * Int(skin)
                    g -= 12 * Int(skin)
                    b -= 10 * Int(skin)
                    if(r > 255){
                        dataType[offset+1] = 255
                    }else if(r < 0){
                        dataType[offset+1] = 0
                    }else{
                        dataType[offset+1] = UInt8(r)
                    }
                    
                    if(g > 255){
                        dataType[offset+2] = 255
                    }else if(g < 0){
                        dataType[offset+2] = 0
                    }else{
                        dataType[offset+2] = UInt8(g)
                    }
                    
                    if(b > 255){
                        dataType[offset+3] = 255
                    }else if(b < 0){
                        dataType[offset+3] = 0
                    }else{
                        dataType[offset+3] = UInt8(b)
                    }
                    
                }
            }
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        let bitmapBytesPerRow = Int(pixelsWide) * 4
        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        let finalcontext = CGBitmapContextCreate(data, pixelsWide, pixelsHigh, (8), (bitmapBytesPerRow), colorSpace, bitmapInfo)
        let imageRef = CGBitmapContextCreateImage(finalcontext)
        
        modelView.image = UIImage(CGImage: imageRef)
        return UIImage(CGImage: imageRef)!
    }

    
    
    
    func process() {
        
        var shirtUI: UIImage = shirtView.image!
        
        var lowResImage = UIImageJPEGRepresentation(shirtUI, 1)
        var shirtCG: CGImage = UIImage(data:lowResImage)!.CGImage
        // Use the above two lines will solve an wierd memory error
        // probably will be fine in an real iphone
        
        // originally intended:
        //      var shirtCG: CGImage = shirtUI.CGImage!
        
        var width  : CGFloat = CGFloat(CGImageGetWidth(shirtCG))
        var height : CGFloat = CGFloat(CGImageGetHeight(shirtCG))
        //println(width)
        var context: CGContext = createARGBBitmapContext(shirtCG)
        var rect :CGRect = CGRectMake(0,0,width,height)
        
        
        CGContextDrawImage(context, rect, shirtCG)
        
        let pixelsWide = CGImageGetWidth(shirtCG)
        let pixelsHigh = CGImageGetHeight(shirtCG)
        
        
        var redP = UnsafeMutablePointer<CGFloat>.alloc(8)
        var color = getcolorfrompoint(context,rect:rect,inImage:shirtCG,x:10,y:20 )
        color.getRed(redP,green:nil,blue:nil,alpha:nil)
        var black = UIColor.blackColor()
        shirtUI = modifyPixel(context, inImage: shirtCG,  color: black)
        shirtView.image = shirtUI
        
        //println(redP.memory * 255)
        
        //print("finish process")
    }
    
    
    func process_skin() {
        
        var modelUI: UIImage = modelView.image!
        
        var lowResImage = UIImageJPEGRepresentation(modelUI, 1)
        var modelCG: CGImage = UIImage(data:lowResImage)!.CGImage
        // Use the above two lines will solve an wierd memory error
        // probably will be fine in an real iphone
        
        // originally intended:
        //      var shirtCG: CGImage = shirtUI.CGImage!
        
        var width  : CGFloat = CGFloat(CGImageGetWidth(modelCG))
        var height : CGFloat = CGFloat(CGImageGetHeight(modelCG))
        //println(width)
        var context: CGContext = createARGBBitmapContext(modelCG)
        var rect :CGRect = CGRectMake(0,0,width,height)
        
        
        CGContextDrawImage(context, rect, modelCG)
        
        let pixelsWide = CGImageGetWidth(modelCG)
        let pixelsHigh = CGImageGetHeight(modelCG)
        
        
        var redP = UnsafeMutablePointer<CGFloat>.alloc(8)
        var color = getcolorfrompoint(context,rect:rect,inImage:modelCG,x:10,y:20 )
        color.getRed(redP,green:nil,blue:nil,alpha:nil)
        var black = UIColor.blackColor()
        modelUI = modifySkin(context, inImage: modelCG, skin: UInt8(5))
        //println("what")
        modelView.image = modelUI
        
        //println(redP.memory * 255)
        
        //print("finish process")
    }

    
    
    
    
}

