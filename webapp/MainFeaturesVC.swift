//
//  MainFeaturesVC.swift
//  webapp
//
//  Created by Timeless on 03/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class MainFeaturesVC: UIViewController {

    @IBOutlet weak var navigateBar: UINavigationBar!
    
    @IBOutlet weak var menuButt: UIBarButtonItem!
    
    var isAnimating: Bool = false
    var dropDownViewIsDisplayed: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
               // change width of navigation bar
            navigateBar.frame=CGRectMake(0, 0, 400, 100)

            self.view .addSubview(navigateBar)
        
        
        navigateBar.setBackgroundImage(UIImage(named:"navigation"),
            forBarMetrics: .Default)
        
        
        menuButt.setBackgroundImage(UIImage(named: "menu_icon"), forState: .Normal, barMetrics: .Default)
        
        
        /*
setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
shadow, NSShadowAttributeName,
[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];*/
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    @IBAction func menuButtonTapped(sender: UIBarButtonItem?) {
        if (self.dropDownViewIsDisplayed) {
            self.hideDropDownView()
        } else {
            self.showDropDownView()
        }
    }
    
    func hideDropDownView() {
        var frame:CGRect = self.dropDownView.frame
        frame.origin.y = -frame.size.height
        self.animateDropDownToFrame(frame) {
            self.dropDownViewIsDisplayed = false
        }
    }
    
    func showDropDownView() {
        var frame:CGRect = self.dropDownView.frame
        frame.origin.y = self.navigateBar.frame.size.height
        self.animateDropDownToFrame(frame) {
            self.dropDownViewIsDisplayed = true
        }
    }
    
    func animateDropDownToFrame(frame: CGRect, completion:() -> Void) {
        if (!self.isAnimating) {
            self.isAnimating = true
            
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut,
                animations: { () -> Void in self.dropDownView.frame = frame
                }, completion:  {(completed: Bool) -> Void in {
                    self.isAnimating = false
                    if (completed) {
                        completion()
                    }
                    }
                })
        }
    }*/
}
