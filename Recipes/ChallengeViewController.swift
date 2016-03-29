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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        reloadTable()
    }
    
    override func viewDidAppear(animated: Bool) {
        reloadTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
