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
    
    @IBOutlet weak var dropDownView: UIView!
    
    var isAnimating: Bool = false
    var dropDownViewIsDisplayed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var height:CGFloat = self.dropDownView.frame.size.height
        var width:CGFloat = self.dropDownView.frame.size.width
        self.dropDownView.frame = CGRectMake(0, -height, width, height)
        self.dropDownViewIsDisplayed = false
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        navigateBar.setBackgroundImage(UIImage(named:"navigation"),
            forBarMetrics: .Default)
        
        
        menuButt.setBackgroundImage(UIImage(named: "menu_icon"), forState: .Normal, barMetrics: .Default)
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
