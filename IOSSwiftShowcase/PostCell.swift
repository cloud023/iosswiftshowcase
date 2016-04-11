//
//  PostCell.swift
//  IOSSwiftShowcase
//
//  Created by Mouse on 09/04/2016.
//  Copyright © 2016 Mouse. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var postImg : UIImageView!;
    @IBOutlet weak var showcaseImg : UIImageView!;
    @IBOutlet weak var descTextView : UITextView!;
    @IBOutlet weak var likesLbl : UILabel!;
    @IBOutlet weak var likeBtn : UIImageView!;
    
    var tapGestureRecognizer : UITapGestureRecognizer!;
    
    var likeRef : Firebase!;
    
    var request : Request?;
    var post : PostData!;
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedLikePostBtn(_:)));
        tapGestureRecognizer.numberOfTapsRequired = 1;
        likeBtn.addGestureRecognizer(tapGestureRecognizer);
        likeBtn.userInteractionEnabled = true;
        
    }
    
    override func drawRect(rect: CGRect) {
        postImg.layer.cornerRadius = postImg.frame.size.width / 2;
        postImg.clipsToBounds = true;
        showcaseImg.clipsToBounds = true;
    }
    
    func configureCell(post : PostData,img :UIImage?){
        self.post = post;
        likesLbl.text = "\(post.likes)";
        descTextView.text = post.description;
        if post.imgUrl != nil {
            if img != nil {
                print("cache image");
                print(post.description);
                self.showcaseImg.image = img;
                
            } else {
                request = Alamofire.request(.GET, post.imgUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, error in
                    print(post.imgUrl);
                    if error == nil {
                        let imageResponse = UIImage(data: data!)!
                        self.showcaseImg.image = imageResponse;
                        UsersPostsVC.imageCache.setObject(imageResponse, forKey: post.imgUrl!);
                    }
                    
                })
            }
        } else {
            showcaseImg.hidden = true;
        }
        
        likeRef = DataService.instance.firebaseLikesRef.childByAppendingPath(post.postKey);
        likeRef.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            if (snapshot.value as? NSNull) != nil {
                self.likeBtn.image = UIImage(named: "heart-inactive");
            } else {
                self.likeBtn.image = UIImage(named: "heart-active");
            }
            
        })
    }
    
    func tappedLikePostBtn(sender : UITapGestureRecognizer){
        likeRef.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            if (snapshot.value as? NSNull) == nil {
                self.likeBtn.image = UIImage(named: "heart-inactive");
                self.post.adjustLikes(false);
                self.likeRef.removeValue();
            } else {
                self.likeBtn.image = UIImage(named: "heart-active");
                self.post.adjustLikes(true);
                self.likeRef.setValue(true);
            }
            
        })
    }

}
