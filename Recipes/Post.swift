//
//  Post.swift
//  Recipes
//
//  Created by Vincent Duong on 3/30/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import Foundation
import Parse
import Bond

// Source: https://www.makeschool.com/tutorials/build-a-photo-sharing-app-part-1/parse-implement-like
class Post : PFObject, PFSubclassing {
    
    //Post object
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    @NSManaged var title: String?
    @NSManaged var descriptions: String?
    @NSManaged var ingredients: [String]?
    @NSManaged var directions: [String]?
    @NSManaged var challenge_id: String?
    @NSManaged var tag: String?
    @NSManaged var like_count: NSNumber?
    @NSManaged var rating_count: NSNumber?
    
    var likes: Observable<[PFUser]?>! = Observable(nil)
    var photoUploadTask: UIBackgroundTaskIdentifier?
    var image: UIImage?
    var likeCount: Int = 0
    var ratingCount: Double = 0
    
    //MARK: PFSubclassing Protocol
    
    //create a connection between the Parse class and your Swift class
    static func parseClassName() -> String {
        return "Post"
    }
    
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    //MARK: Upload
    
    func uploadPost() {
        if let image = image {
            let imageData = UIImageJPEGRepresentation(image, 0.8)!
            let imageFile = PFFile(data: imageData)
            
            // When a background task gets created iOS generates a unique ID and returns it. We store that unique id in the photoUploadTask property.
            photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
            
            // save the imageFile by calling saveInBackgroundWithBlock
            imageFile!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                //  Inform the iOS that our background task is completed. This block gets called as soon as the image upload is finished.
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
            
            // any uploaded post should be associated with the current user
            user = PFUser.currentUser()
            // set up like count to 0
            like_count = 0
            self.imageFile = imageFile
            saveInBackgroundWithBlock(nil)
        }
    }
    
    // MARK: Likes
    
    //Update oberservable var (likes) and store all user who liked this post
    func fetchLikes() {
        if (likes.value != nil) {
            return
        }
        
        ParseHelper.likesForPost(self, completionBlock: { (likes: [PFObject]?, error: NSError?) -> Void in
            if let like = likes {
                // do something with the data fetched
                let l = like.filter { like in like["fromUser"] != nil}
                self.likes.value = l.map { like in
                    let fromUser = like["fromUser"] as! PFUser
                    return fromUser
                }
                self.likeCount = (self.likes.value?.count)!
            }
        })
    }
    
    //Checks if user likes the post
    func doesUserLikePost(user: PFUser) -> Bool {
        if let likes = likes.value {
            return likes.contains(user)
        } else {
            return false
        }
    }
    
    func toggleLikePost(user: PFUser) {
        if (doesUserLikePost(user)) {
            // if recipe is liked, unlike it now
            likes.value = likes.value?.filter { $0 != user }
            ParseHelper.unlikePost(user, post: self)
        } else {
            // if this recipe is not liked yet, like it now
            likes.value?.append(user)
            ParseHelper.likePost(user, post: self)
        }
        //Update like count
        self.likeCount = (self.likes.value?.count)!
        updateLikeCount()
    }
    
    func updateLikeCount() {
        like_count = self.likeCount
        saveInBackgroundWithBlock(nil)
    }
    
    func updateRateCount() {
        rating_count = self.ratingCount
        saveInBackgroundWithBlock(nil)
    }
}