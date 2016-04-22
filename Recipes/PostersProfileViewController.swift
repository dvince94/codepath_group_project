//
//  PostersProfileViewController.swift
//  Recipes
//
//  Created by Lily on 4/18/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse

class PostersProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    var post: Post!
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Bradley Hand", size: 30)!, NSForegroundColorAttributeName: UIColor.blackColor()]
        // Do any additional setup after loading the view.
        usernameLabel.text = "\(post.user!.username!)"
        loadUserInfo()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        reloadTable()
        
        // Initialize a UIRefreshControl
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // Create a white border with defined width
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor;
        profileImage.layer.borderWidth = 1.5;
        
        // Set image corner radius
        profileImage.layer.cornerRadius = 5.0;
        
        // To enable corners to be "clipped"
        profileImage.clipsToBounds = true
        
        usernameLabel.shadowColor = UIColor.whiteColor()
        usernameLabel.shadowOffset = CGSizeMake(2, 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // construct PFQuery and get all recipes
        ParseHelper.otherUserQuery(post.user!, completionBlock: {
            (result: [PFObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            
            refreshControl.endRefreshing()
        });
            
        self.tableView.reloadData()
    }
    
    func reloadTable() {
        // construct PFQuery and get all recipes
        ParseHelper.otherUserQuery(post.user!, completionBlock: {
            (result: [PFObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            self.tableView.reloadData()
        });
    }

    
    func loadUserInfo() {
        if (post.user?.objectForKey("profilePic") != nil) {
            let profilePicFile: PFFile = post.user?.objectForKey("profilePic") as! PFFile
            profilePicFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if (imageData != nil) {
                    self.profileImage.image = UIImage(data: imageData!)
                }
            })
        }
        if (post.user?.objectForKey("backgroundPic") != nil) {
            let backgroundPicFile: PFFile = post.user?.objectForKey("backgroundPic") as! PFFile
            backgroundPicFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if (imageData != nil) {
                    self.backgroundImage.image = UIImage(data: imageData!)
                }
            })
        }
    }
    
    // MARK: Table View Delegate method
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath) as! ProfileCell
        let post = posts[indexPath.row]
        //Get users who liked the post
        post.fetchLikes()
        post.fetchRatings()
        cell.recipe = post
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if sender is ProfileCell {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let recipe = posts[indexPath!.row]
            
            let recipeDetailViewController = segue.destinationViewController as! RecipeDetailViewController
            
            recipeDetailViewController.recipe = recipe
        }
    }

}
