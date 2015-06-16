//
//  UserInfo.swift
//  webapp
//
//  Created by Zhang, Yukai on 16/06/2015.
//  Copyright (c) 2015 Shan, Jinyi. All rights reserved.
//

import Foundation

class UserInfo:NSObject{
    
    var login   :String = ""
    var gender  :Bool = true
    var age     :Int = 0
    var height  :Int = 0
    var weight  :Int = 0
    var skincolor:Int = 0
    
    init(login:String,gender:String,age:String,height:String,weight:String,skincolor:String){
        self.login = login
        if(gender == "f"){
            self.gender = false
        }
        self.age = age.toInt()!
        self.height = height.toInt()!
        self.weight = weight.toInt()!
        self.skincolor = skincolor.toInt()!
    }
    
    
    
    
}