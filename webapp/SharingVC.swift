//
//  SharingVC.swift
//  webapp
//
//  Created by Timeless on 08/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class SharingVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(animated: Bool) {
        // change width of navigation bar
        self.navigationItem.title = "Share to friends"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"navigation2"), forBarMetrics: .Default)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
