//
//  ChallengeDetailViewController.swift
//  Recipes
//
//  Created by Kevin Duong on 3/29/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse

class ChallengeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    var challenge: PFObject!
    var posts: [Post] = []
    var open: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        descriptionLabel.text = challenge["description"] as? String
        ingredientsLabel.text = Recipe.printIngredients(challenge["ingredients"] as! [String])
        self.navigationItem.title = challenge["title"] as? String
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Papyrus", size: 30)!, NSForegroundColorAttributeName: UIColor.blackColor()]
        
        descriptionLabel.preferredMaxLayoutWidth = descriptionLabel.frame.size.width
        
        descriptionLabel.sizeToFit()
        ingredientsLabel.sizeToFit()
        
        var frame = view.frame
        frame.offsetInPlace(dx: 0, dy: containerView.frame.minY)
        
        let constraintHeight: CGFloat = 35 + 209 + 36 + 21 + 50 + 21 + 8 + 81 + 10
        
        frame.size.height = constraintHeight + descriptionLabel.frame.size.height + ingredientsLabel.frame.size.height + dropDownView.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)!

        containerView.frame = frame
        
        tableView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.size.width, height: containerView.frame.origin.y + containerView.frame.size.height)
        
        dropDownView.userInteractionEnabled = true
        
        open = false
        
        
        
//        print(UIScreen.mainScreen().bounds.size.height)
//        print(frame.size.height)
        
        let guesture = UITapGestureRecognizer(target: self, action: "dropDown:")
        self.dropDownView.addGestureRecognizer(guesture)
        
        // Do any additional setup after loading the view.
//        directionsLabel.preferredMaxLayoutWidth = directionsLabel.frame.size.width
        
        reloadTable()
        print(posts.count)
    }
    
    func dropDown(sender:UITapGestureRecognizer) {
        if open == false {
            open = true
        } else {
            open = false
        }
        reloadTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTable() {
        // construct PFQuery and get all recipes
        ParseHelper.challengeQuery(challenge.objectId!, completionBlock: {
            (result: [PFObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            self.tableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if open == false {
            return 0
        }
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipeCell", forIndexPath: indexPath) as! RecipeCell
        let post = posts[indexPath.row]
        //Get users who liked the post
        post.fetchLikes()
        cell.recipe = post
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if sender is UIButton {
            let recipeAddViewController = segue.destinationViewController as! AddRecipeViewController
            
            recipeAddViewController.isChallenge = true
            recipeAddViewController.challenge_id = challenge.objectId!
        } else if sender is RecipeCell {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let recipe = posts[indexPath!.row]
            
            let recipeDetailViewController = segue.destinationViewController as! RecipeDetailViewController
            
            recipeDetailViewController.recipe = recipe
        }
    }
}
