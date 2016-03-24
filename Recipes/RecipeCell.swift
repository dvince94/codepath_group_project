//
//  RecipeCellTableViewCell.swift
//  Recipes
//
//  Created by Kevin Duong on 3/24/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class RecipeCell: UITableViewCell {

    @IBOutlet weak var displayImageView: PFImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    var recipe: PFObject! {
        didSet {
            self.displayImageView.file = recipe["image"] as? PFFile
            self.displayImageView.loadInBackground()
            recipeNameLabel.text = recipe["title"] as? String
            
            ingredientsLabel.text = Recipe.printIngredients(recipe["ingredients"] as! [String])
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
