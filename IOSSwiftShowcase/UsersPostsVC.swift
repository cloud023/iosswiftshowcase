//
//  UsersPostsVC.swift
//  IOSSwiftShowcase
//
//  Created by Mouse on 09/04/2016.
//  Copyright © 2016 Mouse. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class UsersPostsVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var tableView : UITableView!;
    var posts = [PostData]();
    
    static var imageCache = NSCache();
    
    var imagePicker :UIImagePickerController!;
    
    @IBOutlet weak var postImgView: UIImageView!
    
    @IBOutlet weak var postCommentTxtField: UITextField!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self;
        tableView.dataSource = self;
        
        tableView.estimatedRowHeight = 372;
        
        imagePicker = UIImagePickerController();
        imagePicker.delegate = self;
        
        DataService.instance.firebasePostsRef.observeEventType(.Value,withBlock: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                self.posts = [];
                for snap in snapshots {
                    if let postDict = snap.value as? Dictionary<String,AnyObject>{
                        self.posts.append(PostData(postKey: snap.key, valuesDict: postDict));
                    }
                }
            }
            self.tableView.reloadData();
        });
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = posts[indexPath.row];
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell{
            cell.request?.cancel();
            var img: UIImage?;
            
            if  let url = post.imgUrl {
                img = UsersPostsVC.imageCache.objectForKey(url) as? UIImage;
            }
            
            cell.configureCell(post,img: img);
            return cell;
        } else {
            return PostCell();
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let post = posts[indexPath.row];
        
        if post.imgUrl == nil {
            return 178;
        } else {
            return tableView.estimatedRowHeight;
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil);
        postImgView.image = image;
    }
    
    
    @IBAction func tappedPostImg(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil);

    }
    
    @IBAction func tappedPostBtn(sender: AnyObject) {
        
        if let post = postCommentTxtField.text where post != "" {
            
            if  postImgView.image != nil {
                let urlString = "https://post.imageshack.us/upload_api.php";
                let url = NSURL(string: urlString);
                let postImg = postImgView.image;
                let postImgCompressImgData = UIImageJPEGRepresentation(postImg!, 0.2)!;
                let apiKey = "CJZ3KSQB6f4ab20c6c9c89501bcac0cd94c56523".dataUsingEncoding(NSUTF8StringEncoding)!;
                let dataType = "json".dataUsingEncoding(NSUTF8StringEncoding)!;
                Alamofire.upload(.POST,url!, multipartFormData: { multipartFormData in
                    
                    multipartFormData.appendBodyPart(data: postImgCompressImgData, name: "fileupload", fileName: "image", mimeType: "image/jpg");
                    multipartFormData.appendBodyPart(data: apiKey, name: "key");
                    multipartFormData.appendBodyPart(data: dataType, name: "format");
                    
                }) {
                    encodingResult in
                    switch encodingResult{
                    case .Success(let upload,_,_) :
                        upload.responseJSON(completionHandler: { response in
                            if let resultInfo = response.result.value as? Dictionary<String,AnyObject> {
                                if let links = resultInfo["links"] as? Dictionary<String,AnyObject> {
                                    if let imageLink = links["image_link"] as? String{
                                        self.postToFirebase(imageLink);
                                    }
                                }
                            }
                        })
                        
                    case .Failure(let error) :
                        print(error);
                    }
                }
            } else {
                self.postToFirebase(nil);
            }
            
        }
    }
    
    func postToFirebase(image: String?){
        var postData : Dictionary<String,AnyObject> = ["description": postCommentTxtField.text!, "likes" : 0];
        if image != nil {
            postData["imageUrl"] = image!;
        }
        DataService.instance.firebasePostsRef.childByAutoId().updateChildValues(postData);
    }
    
}
