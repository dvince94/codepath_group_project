//
//  ParseHelper.swift
//  Recipes
//
//  Created by Kevin Duong on 3/29/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import Foundation
import Parse

class ParseHelper {
    static func likePost(user: PFUser, post: Recipe) {
        let likeObject = PFObject(className: "Like")
        likeObject["fromUser"] = user
        likeObject["toPost"] = post
        
        likeObject.saveInBackgroundWithBlock(nil)
    }
    
    static func unlikePost(user: PFUser, post: Recipe) {
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
    
    static func likesForPost(post: Recipe, completionBlock: PFQueryArrayResultBlock) {
        let query = PFQuery(className: "Like")
        query.whereKey("toPost", equalTo: post)
        query.includeKey("fromUser")
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
}

