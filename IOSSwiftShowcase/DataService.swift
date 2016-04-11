//
//  DataService.swift
//  IOSSwiftShowcase
//
//  Created by Mouse on 09/04/2016.
//  Copyright © 2016 Mouse. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let instance = DataService();
    
    private var _FIREBASE_BASE_REF = Firebase(url: FIREBASE_BASE_URL);
    private var _FIREBASE_USERS_REF = Firebase(url: "\(FIREBASE_BASE_URL)/users");
    private var _FIREBASE_POSTS_REF = Firebase(url: "\(FIREBASE_BASE_URL)/posts");
    private var _FIREBASE_LIKES_REF = Firebase(url: "\(FIREBASE_BASE_URL)/users");
    
    var firebaseBaseRef : Firebase {
        
        return _FIREBASE_BASE_REF;
    }
    
    var firebaseUsersRef : Firebase{
        return _FIREBASE_USERS_REF;
    }
    
    var firebasePostsRef : Firebase{
        return _FIREBASE_POSTS_REF;
    }
    
    var firebaseLikesRef : Firebase{
        
        get {
            return _FIREBASE_LIKES_REF.childByAppendingPath(User.instance.getUid()).childByAppendingPath("likes");
        }
        
    }
    
    
}