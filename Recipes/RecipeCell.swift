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
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var likesButton: UIButton!
    var likeDisposable: DisposableType?
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameButton: UIButton!
    
    var likeImg: UIImage?
    var unlikeImg: UIImage?
    var getCount: Bool!
    var hour: String?
    var timeStamp: String?
    
    var recipe: Post! {
        didSet {
            //Cancel connection to task
            likeDisposable?.dispose()
            self.displayImageView.file = recipe.imageFile
            self.displayImageView.loadInBackground()
            recipeNameLabel.text = recipe.title
            
            descriptionLabel.text = recipe.descriptions
            descriptionLabel.sizeToFit()
            
            dateLabel.text = recipe.getTimeDifference()
            
            if usernameButton != nil {
                usernameButton.setTitle("\(recipe.user!.username!)", forState: .Normal)
            }
                
            //The observe method takes one parameter, a closure (defined as a trailing closure in the code above),
            //which in our case has type [PFUser]? -> (). 
            //The code defined by the closure will be executed whenever post.likes receives a new value. 
            //The constant named value in the closure definition will contain the actual contents of post.likes
            likeDisposable = recipe.likes.observe { (value: [PFUser]?) -> () in
                if let value = value {
                    if (value.contains(PFUser.currentUser()!)) {
                        self.likesButton.setImage(self.likeImg, forState: .Normal)
                    }
                    else {
                        self.likesButton.setImage(self.unlikeImg, forState: .Normal)
                    }
                }
            }
            
            if (getCount == true) {
                self.likeCount.text! = "\(recipe.like_count!)"
            }
            
            if Rating != nil {
                Rating.didFinishTouchingCosmos = didFinishTouchingCosmos
                
                if(recipe.rating_count != nil) {
                    Rating.rating = recipe.rating_count as! Double
                }
                else {
                    Rating.rating = 0;
                }
            }
            
            displayImageView.layer.cornerRadius = 10.0
            displayImageView.clipsToBounds = true
        }
    }
    
    @IBAction func usernameTouched(sender: AnyObject) {
    }
    
    private func didFinishTouchingCosmos(rating: Double) {
        recipe.updateRating(PFUser.currentUser()!, rate: (rating))
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
            likesButton.setImage(likeImg, forState: .Normal)
        }
        else {
            likesButton.setImage(unlikeImg, forState: .Normal)
        }
        if (getCount == true) {
            likeCount.text! = "\(recipe.like_count!)"
        }
    }
}
