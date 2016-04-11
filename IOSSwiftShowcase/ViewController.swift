//
//  ViewController.swift
//  IOSSwiftShowcase
//
//  Created by Mouse on 08/04/2016.
//  Copyright © 2016 Mouse. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit


class ViewController: UIViewController {

    @IBOutlet weak var emailTxtField : UITextField!;
    @IBOutlet weak var passwordTxtField : UITextField!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        if User.instance.isLoginUser() {
            self.performSegueWithIdentifier(LOGGED_USER_SEGUE_ID, sender: nil);
        }
    }
    
    @IBAction func tappedLoginWithEmailAndPassword(sender : UIButton){
        if let email = emailTxtField.text where email != "", let password = passwordTxtField.text where password != "" {
            DataService.instance.firebaseBaseRef.authUser(email, password: password) { error, authData in
                if error != nil {
                    if error.code == STATUS_ACCOUNT_NOTEXISTS {
                        DataService.instance.firebaseBaseRef.createUser(email, password: password, withValueCompletionBlock: { error, result in
                            if error != nil{
                                self.showErrorAlert("Could not create account", message: error.description);
                            } else {
                                let uid = result["uid"] as! String;
                                print("Successfully created user account with uid: \(uid)");
                                
                                User.instance.saveUserUId(uid);
                                DataService.instance.firebaseUsersRef.authUser(email, password: password, withCompletionBlock: { error, results in
                                    User.instance.saveProfileToFirebase(UserData(username: email,uid: results.uid,provider: results.provider));
                                })
                                
                                self.performSegueWithIdentifier(LOGGED_USER_SEGUE_ID, sender: nil);
                            }
                        });
                    }else {
                        if let title = STATUS_FIREBASE_DICTIONARY[error.code]?["title"], let message = STATUS_FIREBASE_DICTIONARY[error.code]?["message"]{
                            self.showErrorAlert(title, message: message);
                        }
                    }
                    
                }else {
                    User.instance.saveUserUId(authData.uid);
                    self.performSegueWithIdentifier(LOGGED_USER_SEGUE_ID, sender: nil);
                }
            }
        } else {
            showErrorAlert(STATUS_FIREBASE_DICTIONARY[STATUS_ACCOUNT_REQUIRED_EMAILPASSWORD]!["title"]!, message: STATUS_FIREBASE_DICTIONARY[STATUS_ACCOUNT_REQUIRED_EMAILPASSWORD]!["message"]!);
        }
    }
    
    func showErrorAlert(title : String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert);
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil);
        alert.addAction(action);
        self.presentViewController(alert, animated: true, completion: nil);
    }
    
    @IBAction func tappedLoginWithFacebook(sender: AnyObject) {
        let facebookLogin = FBSDKLoginManager();
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self, handler: {
            (facebookResult, facebookError) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                DataService.instance.firebaseBaseRef.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error,authData in
                    if error != nil{
                        print("Login failed \(error)");
                    }else{
                        print("Logged in! \(authData)");
                        User.instance.saveUserUId(authData.uid);
                        User.instance.saveProfileToFirebase(UserData(username: "undefined",uid: authData.uid,provider: "facebook"));
                        self.performSegueWithIdentifier(LOGGED_USER_SEGUE_ID, sender: nil);
                    }
                })
            }
        })
    }
}

