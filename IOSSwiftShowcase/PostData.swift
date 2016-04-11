//
//  PostData.swift
//  IOSSwiftShowcase
//
//  Created by Mouse on 09/04/2016.
//  Copyright © 2016 Mouse. All rights reserved.
//

import Foundation
import Firebase

class PostData {
    
    private var _uid : String!;
    private var _postDescription : String!;
    private var _imgUrl : String?;
    private var _likes : Int!;
    private var _postKey : String!;
    
    private var firebasePostLikes : Firebase?;
    
    var uid : String{
        return _uid;
    }
    
    var description : String {
        get {
            return _postDescription;
        }
        set {
            _postDescription = newValue;
        }
        
    }
    
    var imgUrl : String? {
        get {
            return _imgUrl;
        }
        
        set {
            _imgUrl = newValue;
        }
        
    }
    var likes : Int {
        
        get {
            return _likes;
        }
        
        set {
            _likes = newValue;
        }
    }
    
    var postKey : String{
        return _postKey;
    }
    
    func adjustLikes(isLike : Bool){
        if isLike {
            _likes  = _likes + 1;
        } else {
            _likes = _likes - 1;
        }
        
        firebasePostLikes = DataService.instance.firebasePostsRef.childByAppendingPath(_postKey).childByAppendingPath("likes");
        firebasePostLikes?.setValue(_likes);
    }
    
    init(){
        
    }
    
    init(uid: String, description: String, imgUrl : String,likes : Int){
        self._uid = uid;
        self._postDescription = description;
        self._imgUrl = imgUrl;
        self._likes = likes;
    }
    
    init(postKey : String, valuesDict : Dictionary<String,AnyObject>){
        if let description = valuesDict["description"] as? String{
            self._postDescription = description;
        }
        
        if let imgUrl = valuesDict["imageUrl"] as? String{
            self._imgUrl = imgUrl;
        }
        
        if let likes = valuesDict["likes"] as? Int{
            self._likes = likes;
        }
        
        self._postKey = postKey;
    }
    
}