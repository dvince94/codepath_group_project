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
    
    class func printIngredients(string: [String]) -> String {
        var ingredientPrint = ""
        let ingredients = string;
        for index in 0...(ingredients.count - 1) {
            ingredientPrint += "\u{2022} " + ingredients[index]
            
            if (index != ingredients.count - 1) {
                ingredientPrint += "\n"
            }
        }
        
        return ingredientPrint
    }
    
    class func printDirections(string: [String]) -> String {
        var directionsPrint = ""
        let directions = string;
        
        for index in 0...(directions.count - 1) {
            
            directionsPrint += directions[index] + "\n"
        }
        
        return directionsPrint
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
