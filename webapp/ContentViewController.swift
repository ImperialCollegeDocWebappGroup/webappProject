//
//  ContentViewController.swift
//  webapp
//
//  Created by ZhangZhuofan on 15/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var pageIndex: Int!
    var titleText: String!
    var ImageFile: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = UIImage(named: self.ImageFile)
        self.titleLabel.text = self.titleText
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
