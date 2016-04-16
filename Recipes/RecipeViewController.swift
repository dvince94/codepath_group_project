//
//  RecipeViewController.swift
//  Recipes
//
//  Created by Kevin Duong on 3/16/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse
import Cosmos
class RecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

   
//    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var posts: [Post] = []
    var hideFilter: Bool!
    var current_filter: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        hideFilter = true
//        filterView.hidden = hideFilter
        current_filter = "All"
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }
    
    override func viewDidAppear(animated: Bool) {
        reloadTable(current_filter)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTable(filter: String) {
        // construct PFQuery and get all recipes
        ParseHelper.recipeQuery(current_filter, completionBlock: {
            (result: [PFObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            self.tableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipeCell", forIndexPath: indexPath) as! RecipeCell
        let post = posts[indexPath.row]
        //Get users who liked the post
        post.fetchLikes()
        cell.getCount = false
        cell.recipe = post
        cell.likeImg = UIImage(named: "Like")
        cell.unlikeImg = UIImage(named: "Unlike")
        return cell
    }

//    @IBAction func onFilterClicked(sender: AnyObject) {
//        if hideFilter == true {
//            hideFilter = false
//            filterView.hidden = hideFilter
//        } else {
//            hideFilter = true
//            filterView.hidden = hideFilter
//        }
//    }
    
    @IBAction func onFilterItemClicked(sender: AnyObject) {
        current_filter = sender.currentTitle!
        reloadTable(current_filter)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if sender is RecipeCell {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let recipe = posts[indexPath!.row]
            
            let recipeDetailViewController = segue.destinationViewController as! RecipeDetailViewController
            
            recipeDetailViewController.recipe = recipe
        } else if sender is UIBarButtonItem {
            let recipeAddViewController = segue.destinationViewController as! AddRecipeViewController
            
            recipeAddViewController.isChallenge = false
        }
        
    }
}
