//
//  PostersProfileViewController.swift
//  Recipes
//
//  Created by Lily on 4/18/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse

class PostersProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.text = "\(post.user!.username!)"
        //loadUserInfo()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUserInfo() {
        if (post.user?.objectForKey("profilePic") != nil) {
            let profilePicFile: PFFile = PFUser.currentUser()?.objectForKey("profilePic") as! PFFile
            profilePicFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if (imageData != nil) {
                    self.profileImage.image = UIImage(data: imageData!)
                }
            })
        }
        if (post.user?.objectForKey("backgroundPic") != nil) {
            let backgroundPicFile: PFFile = PFUser.currentUser()?.objectForKey("backgroundPic") as! PFFile
            backgroundPicFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if (imageData != nil) {
                    self.backgroundImage.image = UIImage(data: imageData!)
                }
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
