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
            
            let dateCreated = challenge.createdAt! as NSDate
            let dateFormat = NSDateFormatter()
            let timeFormat = NSDateFormatter()
            dateFormat.dateFormat = "MMM d, yyyy"
            timeFormat.dateFormat = "hh:mm a"
            createdAtLabel.text = "Created on " + (NSString(format: "%@", dateFormat.stringFromDate(dateCreated)) as String) + "\n" + "at " + (NSString(format: "%@", timeFormat.stringFromDate(dateCreated)) as String)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
