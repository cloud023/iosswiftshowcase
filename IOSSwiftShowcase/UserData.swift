//
//  UserData.swift
//  IOSSwiftShowcase
//
//  Created by Mouse on 09/04/2016.
//  Copyright © 2016 Mouse. All rights reserved.
//

import Foundation

class UserData{
    
    private var _username : String!;
    private var _provider : String!;
    private var _uid : String;
    
    var username : String{
        return _username;
    }
    
    var uid : String{
        return _uid;
    }

    var provider : String{
        return _provider;
    }
    
    init(username : String, uid : String,provider : String){
        self._username = username;
        self._uid = uid;
        self._provider = provider;
    }
    
}