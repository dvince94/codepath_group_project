//
//  Recipe.swift
//  Recipes
//
//  Created by Kevin Duong on 3/23/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse
import Bond

class Recipe: NSObject {
    var likes: Observable<[PFUser]?>! = Observable(nil)
    
    /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter ingredients: Ingredients text input by the user
     - parameter directions: Directions text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postRecipe(image: UIImage?, withTitle title: String, withIngredients ingredients: [String]?, withDirections directions: [String]?,withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let recipe = PFObject(className: "Recipe")
        
        // Add relevant fields to the object
        recipe["image"] = getPFFileFromImage(image) // PFFile column type
        recipe["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        recipe["title"] = title
        recipe["ingredients"] = ingredients
        recipe["directions"] = directions
        
//        post["likesCount"] = 0
//        post["commentsCount"] = 0
        
        // Save object (following function will save the object in Parse asynchronously)
        recipe.saveInBackgroundWithBlock(completion)
    }
    
    class func printIngredients(string: [String]) -> String {
        var ingredientPrint = ""
        let ingredients = string;
        for index in 0...(ingredients.count - 1) {
            ingredientPrint += ingredients[index]
            
            if (index != ingredients.count - 1) {
                ingredientPrint += ", "
            }
        }
        
        return ingredientPrint
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    // MARK: Likes
    // Source: https://www.makeschool.com/tutorials/build-a-photo-sharing-app-part-1/parse-implement-like
    
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
    
    func fetchLikes() {
        // 1
        if (likes.value != nil) {
            return
        }
        
        // 2
        Recipe.likesForPost(self, completionBlock: { (var likes: [PFObject]?, error: NSError?) -> Void in
            // 3
            likes = likes?.filter { like in like["fromUser"] != nil }
            
            // 4
            self.likes.value = likes?.map { like in
                let like = like as! PFObject
                let fromUser = like["fromUser"] as! PFUser
                
                return fromUser
            }
        })
    }
    
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
            // 1
            likes.value = likes.value?.filter { $0 != user }
            Recipe.unlikePost(user, post: self)
        } else {
            // if this recipe is not liked yet, like it now
            // 2
            likes.value?.append(user)
            Recipe.likePost(user, post: self)
        }
    }
}
