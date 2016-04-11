//
//  Constants.swift
//  IOSSwiftShowcase
//
//  Created by Mouse on 08/04/2016.
//  Copyright © 2016 Mouse. All rights reserved.
//

import Foundation
import UIKit


let SHADOW_COLOR : CGFloat = 157.0 / 255.0;
let FIREBASE_BASE_URL = "https://ios-swift-realtime.firebaseio.com/";
let USER_UID = "uid";

//SEGUES
let LOGGED_USER_SEGUE_ID = "UsersPostsVC";


//STATUS CODE
let STATUS_ACCOUNT_NOTEXISTS = -8;
let STATUS_ACCOUNT_INVALIDPASSWORD = -6;
let STATUS_ACCOUNT_INVALIDEMAIL = -5;
let STATUS_ACCOUNT_REQUIRED_EMAILPASSWORD = 1;

let STATUS_FIREBASE_DICTIONARY : Dictionary<Int,Dictionary<String,String>> = [
    STATUS_ACCOUNT_INVALIDPASSWORD : ["title" :"Invalid Password","message":"Please enter valid password" ] ,
    STATUS_ACCOUNT_INVALIDEMAIL : ["title" :"Invalid Email","message":"Please enter valid email address" ],
    STATUS_ACCOUNT_REQUIRED_EMAILPASSWORD : ["title" :"Email and Password Required","message":"You must enter your email and password" ]
];