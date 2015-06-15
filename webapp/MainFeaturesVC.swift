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
    
    var shirt: UIImage! = nil
    
    var menus:[String] = ["Load Clothing", "Combine with another", "Add to my wardrobe", "Share to Friends", "Clear Appearance"]
    var sections:[String] = ["Top", "Bottom", "Other", "Whole appearance"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButt.setBackgroundImage(UIImage(named: "menu_icon"), forState: .Normal, barMetrics: .Default)
        
        dropDownMenu.hidden = true
        sectionMenu.hidden = true
        self.navigationItem.title = "FITTING ROOM"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"navigation"), forBarMetrics: .Default)
        shirtView.userInteractionEnabled = true
        /*
        setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
        [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
        shadow, NSShadowAttributeName,
        [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];*/
        
        dropDownMenu.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        shirtView.image = shirt
        if(shirtView.image != nil){
            process()
        }
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
        var cell:UITableViewCell = dropDownMenu.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel!.text = self.menus[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (tableView == dropDownMenu) {
        switch (indexPath.row) {
        case 0:
            self.performSegueWithIdentifier("goto_load", sender: self)
        case 1:
            self.performSegueWithIdentifier("goto_combine", sender: self)
        case 2:
            //add to my collection
            sectionMenu.hidden = false
            
        case 3:
            self.performSegueWithIdentifier("goto_share", sender: self)
        case 4:
            println("selected")
            shirtView.image = nil
        default: ()
        }
        }
        if (tableView == sectionMenu) {
            // choose between top, bottom, other and whole appearance
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
        println("here")
        sender.scale = 1
        
    }
    
   /* @IBAction func saveWholeView(sender: UIButton) {
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var imageData = UIImageJPEGRepresentation(image,1)
        
        var teststring = imageData.base64EncodedStringWithOptions(nil)
        //println(teststring)
        
        postToDB(teststring)
        
    }
*/
    
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
        
        if((j > (wide*10/30))&&(j < wide*20/30) && (i>(hight/6))&&(i<(hight*3/5))){
            return false
        }
        return true
        
    }
    
    private func modifyPixel(context:CGContextRef,inImage: CGImage,color:UIColor)->UIImage{
        typealias RawColorType = (newRedColor:UInt8, newgreenColor:UInt8, newblueColor:UInt8, newalphaValue:UInt8)
        let pixelsWide = CGImageGetWidth(inImage)
        let pixelsHigh = CGImageGetHeight(inImage)
        
        var data = CGBitmapContextGetData(context)
        var dataType = UnsafeMutablePointer<UInt8>(data)
        
        var shirtboundry = 0
        var foundboundry = false
        
        //var whiteLimit:Int = 250
        for i in 0...pixelsHigh{
            for j in 0...pixelsWide{
                let offset = 4*((Int(pixelsWide) * Int(i)) + Int(j))
                if(outrange(i,j:j,wide:pixelsWide,hight:pixelsHigh)&&(dataType[offset] > 240) && dataType[offset+1] > 240 && dataType[offset+2] > 240 && dataType[offset+3] > 240){
                    
                    //println("here")
                    dataType[offset]   = 0
                    dataType[offset+1] = 0
                    dataType[offset+2] = 0
                    dataType[offset+3] = 0
                }
                // above remove background
                
                if(outrange(i,j:j,wide:pixelsWide,hight:pixelsHigh)){
                    
                    if((i < pixelsHigh/7 )&&(dataType[offset+1]>100)){
                        dataType[offset]   = 0
                        dataType[offset+1] = 0
                        dataType[offset+2] = 0
                        dataType[offset+3] = 0
                        // remove head
                        // can add to the second condition as ||
                        // remain this for debugging purpose
                    }else if((dataType[offset+1]>100)&&(dataType[offset+2]>110)&&(dataType[offset+3]<110)){
                        
                        if (!foundboundry && i > pixelsHigh*19/30){
                            
                            shirtboundry = i
                            foundboundry = true
                        }
                        
                        dataType[offset]   = 0
                        dataType[offset+1] = 0
                        dataType[offset+2] = 0
                        dataType[offset+3] = 0
                    }
                }
                
                // above removes human skin
                
                if(foundboundry){
                    dataType[offset]   = 0
                    dataType[offset+1] = 0
                    dataType[offset+2] = 0
                    dataType[offset+3] = 0
                }
                
            }
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        let bitmapBytesPerRow = Int(pixelsWide) * 4
        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        let finalcontext = CGBitmapContextCreate(data, pixelsWide, pixelsHigh, (8), (bitmapBytesPerRow), colorSpace, bitmapInfo)
        let imageRef = CGBitmapContextCreateImage(finalcontext)
        
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
    
    
    
    
}

