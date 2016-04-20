//
//  FavoriteCell.swift
//  Recipes
//
//  Created by Vincent Duong on 4/1/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class FavoriteCell: UITableViewCell {
    
    @IBOutlet weak var displayImageView: PFImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameButton: UIButton!
    
    var recipe: Post! {
        didSet {
            //Cancel connection to task
            self.displayImageView.file = recipe.imageFile
            self.displayImageView.loadInBackground()
            recipeNameLabel.text = recipe.title
            
            descriptionLabel.text = recipe.descriptions
            descriptionLabel.sizeToFit()
            
            displayImageView.layer.cornerRadius = 10.0
            displayImageView.clipsToBounds = true
            
            dateLabel.text = recipe.getTimeDifference()
            
            usernameButton.setTitle("\(recipe.user!.username!)", forState: .Normal)
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
