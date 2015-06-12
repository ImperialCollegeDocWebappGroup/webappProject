//
//  PhotoViewVC.swift
//  webapp
//
//  Created by Zhang, Yukai on 12/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class PhotoViewVC: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var selectButton: UIBarButtonItem = UIBarButtonItem(title: "Select", style: UIBarButtonItemStyle.Plain, target: self, action: "selectTapped:")
        self.navigationItem.rightBarButtonItem = selectButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("selected", sender: self)
        
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
     //   println("called")
        if segue.identifier == "selected" {
            
        
        println(segue.destinationViewController.description)
        println(segue.sourceViewController.description)
        println(segue.identifier)
        var svc = segue.destinationViewController as! MainFeaturesVC;
        svc.shirt = imgView.image
        }
   
    }
    
}
