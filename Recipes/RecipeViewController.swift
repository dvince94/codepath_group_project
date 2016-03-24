//
//  RecipeViewController.swift
//  Recipes
//
//  Created by Kevin Duong on 3/16/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse

class RecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var recipes: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        reloadTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTable() {
        // construct PFQuery
        let query = PFQuery(className: "Recipe")
//        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (recipes: [PFObject]?, error: NSError?) -> Void in
            if let recipes = recipes {
                // do something with the data fetched
                self.recipes = recipes
                self.tableView.reloadData()
                
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recipes != nil {
            return recipes!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipeCell", forIndexPath: indexPath) as! RecipeCell
        
        cell.recipe = recipes![indexPath.row]
        
        return cell
    }
    
    static let userDidLogoutNotification = "userDidLogout"
    
//    @IBAction func onLogout(sender: AnyObject) {
//        PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
//            if error != nil {
//                print(error?.localizedDescription)
//            } else {
//                print("logout true")
//                NSNotificationCenter.defaultCenter().postNotificationName(RecipeViewController.userDidLogoutNotification, object: nil)
//            }
//        }
//    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
