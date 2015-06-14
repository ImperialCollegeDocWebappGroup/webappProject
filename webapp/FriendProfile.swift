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
    
    @IBOutlet weak var icon: UIImageView!
    let link1 : String = "http://www.doc.ic.ac.uk/~jl6613/babyicon.jpeg"
    
    var iconUrl: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        FriendName.text = name
        // Do any additional setup after loading the view.
        let url = NSURL(string: iconUrl)
        if let data1 = NSData(contentsOfURL: url!) {
            println("!!!!!2")
            icon.image = UIImage(data:data1)
            
        }

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
