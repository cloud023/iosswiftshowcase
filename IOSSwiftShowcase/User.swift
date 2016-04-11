//
//  UserService.swift
//  IOSSwiftShowcase
//
//  Created by Mouse on 09/04/2016.
//  Copyright © 2016 Mouse. All rights reserved.
//

import Foundation

class User {
    
    static let instance = User();
    
    func saveUserUId(uid : String){
        NSUserDefaults.standardUserDefaults().setObject(uid, forKey: USER_UID);
        NSUserDefaults.standardUserDefaults().synchronize();
    }
    
    func getUid() -> String? {
        return NSUserDefaults.standardUserDefaults().objectForKey(USER_UID) as? String;
    }
    
    func saveProfileToFirebase(userData: UserData){
        let userDataToSave = [userData.uid: ["username":userData.username,"provider":userData.provider]];
        DataService.instance.firebaseUsersRef.updateChildValues(userDataToSave);
    }
    
    func isLoginUser() -> Bool{
        if NSUserDefaults.standardUserDefaults().objectForKey(USER_UID) != nil {
            return true;
        }
        return false;
    }
    
    func logoutUser() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(USER_UID);
        NSUserDefaults.standardUserDefaults().synchronize();
    }
    
}