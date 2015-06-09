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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        navigateBar.setBackgroundImage(UIImage(named:"navigation"),
            forBarMetrics: .Default)
    }
}
