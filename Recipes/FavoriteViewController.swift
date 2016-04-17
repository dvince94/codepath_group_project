//
//  FavoriteViewController.swift
//  Recipes
//
//  Created by Vincent Duong on 4/1/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var toggleButton: UIBarButtonItem!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var posts: [Post] = []
    var toggleView: Bool!
    var tableImg = UIImage(named: "table")
    var collectionImg = UIImage(named: "collection")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Favorite"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Bradley Hand", size: 30)!, NSForegroundColorAttributeName: UIColor.blackColor()]
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        view2.hidden = true
        toggleView = true
    }
    
    override func viewDidAppear(animated: Bool) {
        reloadTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTable() {
        // construct PFQuery and get all recipes
        ParseHelper.favoriteQuery {
            (result: [PFObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            if self.toggleView == true {
                self.tableView.reloadData()
            }
            else {
                self.collectionView.reloadData()
            }
            
        }
    }
    
    @IBAction func toggleButtonTapped(sender: AnyObject) {
        if (toggleView == true) {
            toggleView = false
            view2.hidden = false
            toggleButton.image = tableImg
        }
        else {
            toggleView = true
            view2.hidden = true
            toggleButton.image = collectionImg
        }
        reloadTable()
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
        }
    }
    

}
