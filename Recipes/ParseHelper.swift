//
//  ParseHelper.swift
//  Recipes
//
//  Created by Kevin Duong on 3/29/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import Foundation
import Parse

// Source: https://www.makeschool.com/tutorials/build-a-photo-sharing-app-part-1/parse-implement-like
class ParseHelper {
    
    //Query post from current user
    static func userQuery(completionBlock: PFQueryArrayResultBlock?) {
        
        let postsFromThisUser = Post.query()
        postsFromThisUser!.whereKey("user", equalTo: PFUser.currentUser()!)
        
        let query = PFQuery.orQueryWithSubqueries([postsFromThisUser!])
        query.includeKey("user")
        query.orderByDescending("createdAt")
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    //Query of user's liked post
    static func favoriteQuery(completionBlock: PFQueryArrayResultBlock?) {
        let followingQuery = PFQuery(className: "Like")
        followingQuery.whereKey("fromUser", equalTo:PFUser.currentUser()!)
        
        let postsFromFollowedUsers = Post.query()
        postsFromFollowedUsers!.whereKey("id", matchesKey: "post", inQuery: followingQuery)
        
        let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!])
        query.includeKey("user")
        //query.orderByDescending("createdAt")
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    //Query for all recipes
    static func recipeQuery(completionBlock: PFQueryArrayResultBlock?) {
        let query = PFQuery(className: "Post")
        query.includeKey("user")
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    
    //Likes a post
    static func likePost(user: PFUser, post: Post) {
        let likeObject = PFObject(className: "Like")
        likeObject["fromUser"] = user
        likeObject["toPost"] = post
        
        likeObject.saveInBackgroundWithBlock(nil)
    }
    
    //Deletes a like, when user unlikes post
    static func unlikePost(user: PFUser, post: Post) {
        let query = PFQuery(className: "Like")
        query.whereKey("fromUser", equalTo: user)
        query.whereKey("toPost", equalTo: post)
        
        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
            if let results = results as [PFObject]? {
                for likes in results {
                    likes.deleteInBackgroundWithBlock(nil)
                }
            }
        }
    }
    
    //Fetch all likes for a given post
    static func likesForPost(post: Post, completionBlock: PFQueryArrayResultBlock) {
        let query = PFQuery(className: "Like")
        query.whereKey("toPost", equalTo: post)
        query.includeKey("fromUser")
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
}

extension PFObject {
    //Overrides the equal class and compares object by objectId rather than by the PFUser object
    //since there can be multiple different PFUser that represents the same user
    //and there object ID remains the same
    public override func isEqual(object: AnyObject?) -> Bool {
        if (object as? PFObject)?.objectId == self.objectId {
            return true
        } else {
            return super.isEqual(object)
        }
    }
    
}

