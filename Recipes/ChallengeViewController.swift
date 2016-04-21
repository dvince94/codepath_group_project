//
//  ChallengeViewController.swift
//  Recipes
//
//  Created by Kevin Duong on 3/29/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse

class ChallengeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var challenges: [PFObject]?
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Challenge"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Bradley Hand", size: 30)!, NSForegroundColorAttributeName: UIColor.blackColor()]
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        // Initialize a UIRefreshControl
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        reloadTable()
    }
    
    override func viewDidAppear(animated: Bool) {
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
        
        // construct PFQuery
        let query = PFQuery(className: "Challenge")
        //        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (challenges: [PFObject]?, error: NSError?) -> Void in
            if let challenges = challenges {
                // do something with the data fetched
                self.challenges = challenges
                
            } else {
                print(error?.localizedDescription)
            }
        }
        refreshControl.endRefreshing()
        self.tableView.reloadData()
        
    }
    
    func reloadTable() {
        // construct PFQuery
        let query = PFQuery(className: "Challenge")
        //        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (challenges: [PFObject]?, error: NSError?) -> Void in
            if let challenges = challenges {
                // do something with the data fetched
                self.challenges = challenges
                self.tableView.reloadData()
                
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }
        
        // construct PFQuery and get all recipes
//        ParseHelper.allChallengesQuery {
//            (result: [NSObject]?, error: NSError?) -> Void in
//            self.challenges = result as? [Challenge] ?? []
//            self.tableView.reloadData()
//        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if challenges != nil {
            return challenges!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChallengeCell", forIndexPath: indexPath) as! ChallengeCell
        
        cell.challenge = challenges![indexPath.row]
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if sender is ChallengeCell {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let challenge = challenges![indexPath!.row]
            
            let challengeDetailViewController = segue.destinationViewController as! ChallengeDetailViewController
            
            challengeDetailViewController.challenge = challenge
        }
    }
}
