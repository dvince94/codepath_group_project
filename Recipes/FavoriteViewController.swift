//
//  FavoriteViewController.swift
//  Recipes
//
//  Created by Vincent Duong on 4/1/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var toggleButton: UIBarButtonItem!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterMenuButton: UIBarButtonItem!

    var posts: [Post] = []
    var toggleView: Bool!
    var tableImg = UIImage(named: "table")
    var collectionImg = UIImage(named: "collection")
    let refreshControl = UIRefreshControl()
    var current_filter: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Favorite"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Bradley Hand", size: 30)!, NSForegroundColorAttributeName: UIColor.blackColor()]
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        // Initialize a UIRefreshControl
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        view2.hidden = true
        toggleView = true
        
        filterMenuButton.target = self.revealViewController()
        filterMenuButton.action = Selector("revealToggle:")
        
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func viewDidAppear(animated: Bool) {
        if current_filter == nil {
            current_filter = "All"
        }
        reloadTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        ParseHelper.favoriteQuery(current_filter, completionBlock: {
            (result: [PFObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
        })
        if self.toggleView == true {
            self.tableView.reloadData()
        }
        else {
            self.collectionView.reloadData()
        }
    }
    
    func reloadTable() {
        // construct PFQuery and get all recipes
        ParseHelper.favoriteQuery(current_filter, completionBlock: {
            (result: [PFObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            if self.toggleView == true {
                self.tableView.reloadData()
            }
            else {
                self.collectionView.reloadData()
            }
            
        })
    }
    
    @IBAction func toggleButtonTapped(sender: AnyObject) {
        if (toggleView == true) {
            toggleView = false
            view2.hidden = false
            toggleButton.image = tableImg
            collectionView.insertSubview(refreshControl, atIndex: 0)
        }
        else {
            toggleView = true
            view2.hidden = true
            toggleButton.image = collectionImg
            tableView.insertSubview(refreshControl, atIndex: 0)
        }
        reloadTable()
    }
    
    //MARK: Searchbar Delegate
    
    //Search bar delegate methods
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        doSearch(searchBar.text!)
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var search = searchBar.text
        if (containText(search!) == true) {
            doSearch(search!)
        }
        else {
            search = ""
            doSearch(search!)
        }
        searchBar.resignFirstResponder()
    }
    
    private func doSearch(search: String) {
        ParseHelper.searchQuery(search, completionBlock: {
            (result: [PFObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            if self.toggleView == true {
                self.tableView.reloadData()
            }
            else {
                self.collectionView.reloadData()
            }
        })
    }
    
    //Check if it contains any text
    func containText(str: String) -> Bool {
        let whiteSpaceSet = NSCharacterSet.whitespaceCharacterSet()
        if str.stringByTrimmingCharactersInSet(whiteSpaceSet) != "" {
            return true
        }
        return false
    }
    
    //MARK: Collectionview Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! CollectionCell
        
        let post = posts[indexPath.row]
        //Get users who liked the post
        post.fetchLikes()
        cell.recipe = post
        
        return cell
    }

    
    //MARK: Tableview Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteCell", forIndexPath: indexPath) as! FavoriteCell
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
        
        if sender is FavoriteCell {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let recipe = posts[indexPath!.row]
            
            let recipeDetailViewController = segue.destinationViewController as! RecipeDetailViewController
            
            recipeDetailViewController.recipe = recipe
        }
        if sender is CollectionCell {
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPathForCell(cell)
            let recipe = posts[indexPath!.row]
            
            let recipeDetailViewController = segue.destinationViewController as! RecipeDetailViewController
            
            recipeDetailViewController.recipe = recipe
        } else if segue.identifier == "profileSegue" {
            let postersProfileViewController = segue.destinationViewController as! PostersProfileViewController
            if let button = sender as? UIButton {
                let cell = button.superview?.superview as! UITableViewCell
                let indexPath = self.tableView.indexPathForCell(cell)
                postersProfileViewController.post = posts[indexPath!.row]
            }
        }
    }
    

}
