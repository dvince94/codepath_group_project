//
//  ProfileViewController.swift
//  Recipes
//
//  Created by Lily on 3/22/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var posts: [Post] = []
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = PFUser.currentUser()?.username
        loadUserInfo()
        self.navigationItem.title = "Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Bradley Hand", size: 30)!, NSForegroundColorAttributeName: UIColor.blackColor()]
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        reloadTable()
        
        // Initialize a UIRefreshControl
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        reloadTable()
        loadUserInfo()
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
        ParseHelper.userQuery {
            (result: [PFObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            
            refreshControl.endRefreshing()
        }
        self.tableView.reloadData()
    }
    
    func reloadTable() {
        // construct PFQuery and get all recipes
        ParseHelper.userQuery {
            (result: [PFObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            self.tableView.reloadData()
        }
    }
    
    // MARK: Logout
    
    static let userDidLogoutNotification = "userDidLogout"
    
    @IBAction func onLogout(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                print("logout true")
                NSNotificationCenter.defaultCenter().postNotificationName(ProfileViewController.userDidLogoutNotification, object: nil)
            }
        }
    }

    // MARK: Table View Delegate method
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileCell
        let post = posts[indexPath.row]
        //Get users who liked the post
        post.fetchLikes()
        cell.recipe = post
        
        return cell
    }
    
    func loadUserInfo() {
        if (PFUser.currentUser()?.objectForKey("profilePic") != nil) {
            let profilePicFile: PFFile = PFUser.currentUser()?.objectForKey("profilePic") as! PFFile
            profilePicFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if (imageData != nil) {
                    self.profileImage.image = UIImage(data: imageData!)
                }
            })
        }
        if (PFUser.currentUser()?.objectForKey("backgroundPic") != nil) {
            let backgroundPicFile: PFFile = PFUser.currentUser()?.objectForKey("backgroundPic") as! PFFile
            backgroundPicFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if (imageData != nil) {
                    self.backgroundImage.image = UIImage(data: imageData!)
                }
            })
        }
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
