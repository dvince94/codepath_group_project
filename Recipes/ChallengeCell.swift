//
//  ChallengeViewCell.swift
//  Recipes
//
//  Created by Kevin Duong on 3/29/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse

class ChallengeCell: UITableViewCell {

    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var challenge: PFObject! {
        didSet {
            recipeNameLabel.text = challenge["title"] as? String
            let user = challenge["author"] as? PFUser
            authorNameLabel.text = "by " + ((user?.username)! as String)
            ingredientsLabel.text = Recipe.printIngredients(challenge["ingredients"] as! [String])
            descriptionLabel.text = challenge["descritption"] as? String
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
