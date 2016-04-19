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
    
    //Query post from current challenge
    static func challengeQuery(challenge_id: String, completionBlock: PFQueryArrayResultBlock?) {
        
        let postsFromChallenges = Post.query()
        postsFromChallenges!.whereKey("challenge_id", equalTo: challenge_id)
        
        let query = PFQuery.orQueryWithSubqueries([postsFromChallenges!])
        query.includeKey("user")
        query.orderByDescending("like_count")
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    //Query of user's liked post
    static func favoriteQuery(completionBlock: PFQueryArrayResultBlock?) {
        let followingQuery = PFQuery(className: "Like")
        followingQuery.whereKey("fromUser", equalTo:PFUser.currentUser()!)
        
        let postsFromLikedUsers = Post.query()
        postsFromLikedUsers!.whereKey("objectId", matchesKey: "postId", inQuery: followingQuery)
        
        let query = PFQuery.orQueryWithSubqueries([postsFromLikedUsers!])
        query.includeKey("user")
        //query.orderByDescending("createdAt")
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    /*//Query of user's rated post
    static func rateQuery(completionBlock: PFQueryArrayResultBlock?) {
    let followingQuery = PFQuery(className: "Rate")
    followingQuery.whereKey("fromUser", equalTo:PFUser.currentUser()!)
    
    let postsFromRatedUsers = Post.query()
    postsFromRatedUsers!.whereKey("objectId", matchesKey: "postId", inQuery: followingQuery)
    
    let query = PFQuery.orQueryWithSubqueries([postsFromRatedUsers!])
    query.includeKey("user")
    //query.orderByDescending("createdAt")
    query.limit = 20
    
    query.findObjectsInBackgroundWithBlock(completionBlock)
    }*/
    
    //Query for all recipes
    static func recipeQuery(filter: String!, completionBlock: PFQueryArrayResultBlock?) {
        
        let postsFromNonChallenges = Post.query()
        postsFromNonChallenges!.whereKey("challenge_id", equalTo: "0")
        if filter != "All" {
            postsFromNonChallenges!.whereKey("tag", equalTo: filter)
        }
        
        let query = PFQuery.orQueryWithSubqueries([postsFromNonChallenges!])
        query.includeKey("user")
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    //Search
    static func searchQuery(search: String!, completionBlock: PFQueryArrayResultBlock?) {
        let postsFromNonChallenges = Post.query()
        postsFromNonChallenges!.whereKey("challenge_id", equalTo: "0")
        if search != "" {
            postsFromNonChallenges?.whereKey("title", containsString: search)
        }
        
        let query = PFQuery.orQueryWithSubqueries([postsFromNonChallenges!])
        query.includeKey("user")
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    //MARK: Rate
    static func ratePost(user: PFUser, post: Post, rating: Int) {
        let ratedObject = PFObject(className: "Rate")
        ratedObject["fromUser"] = user
        ratedObject["toPost"] = post
        ratedObject["postId"] = post.objectId
        ratedObject["rating"] = rating
        ratedObject.saveInBackgroundWithBlock(nil)
    }
    
    static func updateRating(user: PFUser, post: Post, rating: Int) {
        let query = PFQuery(className: "Rate")
        query.whereKey("fromUser", equalTo: user)
        query.whereKey("toPost", equalTo: post)
        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
            if let results = results as [PFObject]? {
                for r in results {
                    r["rating"] = rating
                    r.saveInBackgroundWithBlock(nil)
                }
            }
        }
    }
    
    //Fetch all rating for a given post
    static func ratingForPost(post: Post, completionBlock: PFQueryArrayResultBlock) {
        let query = PFQuery(className: "Rate")
        query.whereKey("toPost", equalTo: post)
        query.includeKey("fromUser")
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    //MARK: Like
    
    //Likes a post
    static func likePost(user: PFUser, post: Post) {
        let likeObject = PFObject(className: "Like")
        likeObject["fromUser"] = user
        likeObject["toPost"] = post
        likeObject["postId"] = post.objectId
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

