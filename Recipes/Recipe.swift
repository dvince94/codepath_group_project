//
//  Recipe.swift
//  Recipes
//
//  Created by Kevin Duong on 3/23/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse

class Recipe: NSObject {
    /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter ingredients: Ingredients text input by the user
     - parameter directions: Directions text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postUserImage(image: UIImage?, withIngredients ingredients: [String]?, withDirections directions: [String]?,withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let recipe = PFObject(className: "Recipe")
        
        // Add relevant fields to the object
        recipe["image"] = getPFFileFromImage(image) // PFFile column type
        recipe["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        recipe["ingredients"] = ingredients
        recipe["directions"] = directions
        
//        post["likesCount"] = 0
//        post["commentsCount"] = 0
        
        // Save object (following function will save the object in Parse asynchronously)
        recipe.saveInBackgroundWithBlock(completion)
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
}
