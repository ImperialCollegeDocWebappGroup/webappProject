//
//  FriendProfile.swift
//  webapp
//
//  Created by ZhangZhuofan on 12/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class FriendProfile: UIViewController {

    @IBOutlet weak var FriendName: UILabel!
    
    var name : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FriendName.text = name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
