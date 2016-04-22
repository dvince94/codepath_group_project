//
//  RecipeDetailViewController.swift
//  Recipes
//
//  Created by Lily on 3/22/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bond
import Cosmos
class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var recipeImage: PFImageView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var screenSuperView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var Rating: CosmosView!
    
    var recipe: Post!
    var likeDisposable: DisposableType?
    var likeImg = UIImage(named: "Like")
    var unlikeImg = UIImage(named: "Unlike")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Rating != nil {
            Rating.didFinishTouchingCosmos = didFinishTouchingCosmos
            
            if(recipe.rating_count != nil) {
                Rating.rating = recipe.rating_count as! Double
            }
            else {
                Rating.rating = 0;
            }
        }
        
        
        /*
        Rating.rating = recipe.ratings.observe { (value: [PFUser]?) -> () in
            if let value = value {
                if (value.contains(PFUser.currentUser()!)) {
                    
                } else {
                
                }
            }
        }
        */
        
        // the likes
        likeDisposable?.dispose()
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
        
        descriptionLabel.text = recipe.descriptions! as String
        ingredientsLabel.text = Recipe.printIngredients(recipe.ingredients! as [String])
//        directionsLabel.text = Recipe.printDirections(recipe.directions! as [String])
        self.recipeImage.file = recipe.imageFile
        self.recipeImage.loadInBackground()
        // puts title on navigation bar..changes size, color, and font of title
        self.navigationItem.title = recipe.title! as String
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Papyrus", size: 30)!, NSForegroundColorAttributeName: UIColor.blackColor()]
        
        // Do any additional setup after loading the view.
        directionsLabel.preferredMaxLayoutWidth = directionsLabel.frame.size.width
        ingredientsLabel.sizeToFit()
        directionsLabel.sizeToFit()
        descriptionLabel.sizeToFit()
        
        let style = NSMutableParagraphStyle()
        style.paragraphSpacing = 5
        let attributes = [NSParagraphStyleAttributeName: style]
        directionsLabel.attributedText = NSAttributedString(string: Recipe.printDirections(recipe.directions! as [String]), attributes: attributes)
        
        // center containerView
        let scrollViewBounds = scrollView.bounds
        let containerViewBounds = contentView.bounds
        
        var scrollViewInsets = UIEdgeInsetsZero
        scrollViewInsets.top = scrollViewBounds.size.height/2.0
        scrollViewInsets.top -= containerViewBounds.size.height/2.0
        
        scrollViewInsets.bottom = scrollViewBounds.size.height/2.0
        scrollViewInsets.bottom -= containerViewBounds.size.height/2.0
        scrollViewInsets.bottom += 1
        
        scrollView.contentInset = scrollViewInsets
        
        
        // make profileImage a circle
        userImage.layer.cornerRadius = userImage.frame.size.height/2
        userImage.layer.masksToBounds = true
        userImage.layer.borderWidth = 0
        
        usernameLabel.text = "by " + (recipe.user?.username)!
        
        
        // set the user's profile pic
        if (recipe.user?.objectForKey("profilePic") != nil) {
            print("not nil")
            let profilePicFile: PFFile = recipe.user?.objectForKey("profilePic") as! PFFile
            profilePicFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if (imageData != nil) {
                    self.userImage.image = UIImage(data: imageData!)
                }
            })
        }
        
    }
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        recipe.toggleLikePost(PFUser.currentUser()!)
        if (recipe.doesUserLikePost(PFUser.currentUser()!)) {
            likesButton.setImage(likeImg, forState: .Normal)
        }
        else {
            likesButton.setImage(unlikeImg, forState: .Normal)
        }
    }
    
    
    private func didFinishTouchingCosmos(rating: Double) {
        recipe.updateRating(PFUser.currentUser()!, rate: (rating))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
