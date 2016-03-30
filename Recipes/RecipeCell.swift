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
import Bond
import Cosmos
class RecipeCell: UITableViewCell {

    @IBOutlet weak var Rating: CosmosView!
    
    @IBOutlet weak var displayImageView: PFImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var likesButton: UIButton!
    var likeDisposable: DisposableType?
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var recipe: Post! {
        didSet {
            //Cancel connection to task
            likeDisposable?.dispose()
            self.displayImageView.file = recipe.imageFile
            self.displayImageView.loadInBackground()
            recipeNameLabel.text = recipe.title
            
            descriptionLabel.text = recipe.descriptions
            descriptionLabel.sizeToFit()
            
            //The observe method takes one parameter, a closure (defined as a trailing closure in the code above), 
            //which in our case has type [PFUser]? -> (). 
            //The code defined by the closure will be executed whenever post.likes receives a new value. 
            //The constant named value in the closure definition will contain the actual contents of post.likes
            likeDisposable = recipe.likes.observe { (value: [PFUser]?) -> () in
                if let value = value {
                    if (value.contains(PFUser.currentUser()!)) {
                        let image = UIImage(named: "Like.png")
                        self.likesButton.setImage(image, forState: .Normal)
                    }
                }
            }
            
            displayImageView.layer.cornerRadius = 10.0
            displayImageView.clipsToBounds = true
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
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        recipe.toggleLikePost(PFUser.currentUser()!)
        if (recipe.doesUserLikePost(PFUser.currentUser()!)) {
            let image = UIImage(named: "Like.png")
            likesButton.setImage(image, forState: .Normal)
        }
        else {
            let image = UIImage(named: "Unlike.png")
            likesButton.setImage(image, forState: .Normal)
        }
    }

}
