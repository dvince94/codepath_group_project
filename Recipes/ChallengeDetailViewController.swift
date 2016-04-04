//
//  ChallengeDetailViewController.swift
//  Recipes
//
//  Created by Kevin Duong on 3/29/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse

class ChallengeDetailViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    var challenge: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.text = challenge["description"] as? String
        ingredientsLabel.text = Recipe.printIngredients(challenge["ingredients"] as! [String])
        self.navigationItem.title = challenge["title"] as? String
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Papyrus", size: 30)!, NSForegroundColorAttributeName: UIColor.blackColor()]
        
        descriptionLabel.preferredMaxLayoutWidth = descriptionLabel.frame.size.width
        
        descriptionLabel.sizeToFit()
        ingredientsLabel.sizeToFit()
        
        var frame = view.frame
        frame.offsetInPlace(dx: 0, dy: containerView.frame.minY)
        
        let constraintHeight: CGFloat = 35 + 209 + 36 + 21 + 50 + 21 + 8 + 81
        
        frame.size.height = constraintHeight + descriptionLabel.frame.size.height + ingredientsLabel.frame.size.height + dropDownView.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)!

        containerView.frame = frame
        
        tableView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.size.width, height: containerView.frame.origin.y + containerView.frame.size.height)
        
//        let guesture = UITapGestureRecognizer(target: self, action: "dropDown:")
//        self.dropDownView.addGestureRecognizer(guesture)
        
        // Do any additional setup after loading the view.
//        directionsLabel.preferredMaxLayoutWidth = directionsLabel.frame.size.width
    }
    
    func dropDown(sender:UITapGestureRecognizer) {
        print("hi")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if sender is ChallengePlusButton {
            let recipeAddViewController = segue.destinationViewController as! AddRecipeViewController
            
            recipeAddViewController.isChallenge = true
            recipeAddViewController.challenge_id = challenge.objectId!
        }
    }
}
