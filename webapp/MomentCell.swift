//
//  MomentCell.swift
//  webapp
//
//  Created by Zhang, Zhuofan on 10/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import UIKit

class MomentCell: UITableViewCell {
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var publishTime: UILabel!
    
    
    @IBOutlet weak var momentsIcon: UIImageView!
    
    @IBOutlet weak var momentsPhoto: UIImageView!
    
    @IBOutlet weak var commentButton: UIButton!
    
    var selectedName :String = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  
    
    @IBAction func commentTapped(sender: UIButton) {
        println(username.text! +  " comment Tapped")
    }
    
    

}
