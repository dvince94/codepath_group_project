//
//  ProfileCell.swift
//  Recipes
//
//  Created by Lily on 3/29/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileCell: UITableViewCell {

    @IBOutlet weak var recipeImage: PFImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    var recipe: Post! {
        didSet {
            self.recipeImage.file = recipe.imageFile
            self.recipeImage.loadInBackground()
            recipeNameLabel.text = recipe.title
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
