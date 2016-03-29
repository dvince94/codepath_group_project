//
//  Challenge.swift
//  Recipes
//
//  Created by Kevin Duong on 3/29/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse

class Challenge: NSObject {
    
    class func postChallenge(title title: String, withIngredients ingredients: [String]?, withDescription description: String, withCompletion completion: PFBooleanResultBlock?) {
        
        let challenge = PFObject(className: "Challenge")
        
        challenge["title"] = title
        challenge["ingredients"] = ingredients
        challenge["description"] = description
        challenge["author"] = PFUser.currentUser()
        
        challenge.saveInBackgroundWithBlock(completion)
    }
}
