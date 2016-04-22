//
//  ChallengeViewCell.swift
//  Recipes
//
//  Created by Kevin Duong on 3/29/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse

class ChallengeCell: UITableViewCell {

    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var challenge: PFObject! {
        didSet {
            recipeNameLabel.text = challenge["title"] as? String
            recipeNameLabel.sizeToFit()
            let user = challenge["author"] as? PFUser
            authorNameLabel.text = "By " + ((user?.username)! as String)
            descriptionLabel.text = challenge["description"] as? String
            createdAtLabel.text = getTimeDifference()
            //let dateCreated = challenge.createdAt! as NSDate
            //let dateFormat = NSDateFormatter()
            //let timeFormat = NSDateFormatter()
            //dateFormat.dateFormat = "MMM d, yyyy"
            //timeFormat.dateFormat = "hh:mm a"
            //createdAtLabel.text = "Created on " + (NSString(format: "%@", dateFormat.stringFromDate(dateCreated)) as String) + "\n" + "at " + (NSString(format: "%@", timeFormat.stringFromDate(dateCreated)) as String)
            createdAtLabel.sizeToFit()
            
            if (PFUser.currentUser()?.objectForKey("profilePic") != nil) {
                let profilePicFile: PFFile = PFUser.currentUser()?.objectForKey("profilePic") as! PFFile
                profilePicFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                    if (imageData != nil) {
                        self.profileImage.image = UIImage(data: imageData!)
                    }
                })
            }
           
        }
    }
    
    func getTimeDifference() -> String! {
        let elapsedTime = NSDate().timeIntervalSinceDate(challenge.createdAt!)
        let time_in_int = NSInteger(elapsedTime)
        let (year, month, day, hours, minutes, seconds)  = convertSeconds(time_in_int)
        if year > 1 {
            return "\(year)y"
        }
        else if month > 1 {
            return "\(month)m"
        }
        else if day > 1 {
            return "\(day)d"
        }
        else if hours > 1 {
            return "\(hours)h"
        }
        else if minutes > 1 {
            return "\(minutes)m"
        }
        else {
            return "\(seconds)s"
        }
    }
    
    func convertSeconds (seconds : Int) -> (Int, Int, Int, Int, Int, Int) {
        return (seconds / 31557600, seconds / 2628000, seconds / (3600 * 24), seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
