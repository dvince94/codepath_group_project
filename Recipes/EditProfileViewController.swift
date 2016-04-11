//
//  EditProfileViewController.swift
//  Recipes
//
//  Created by Lily on 4/4/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var profilePicEdited = false
    var backgroundPicEdited = false
    var profilePic: NSData!
    var backgroundPic: NSData!
    var profile: ProfileViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = PFUser.currentUser()?.username
        loadUserInfo()
        self.navigationItem.title = "Edit Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Bradley Hand", size: 30)!, NSForegroundColorAttributeName: UIColor.blackColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func profilePicTouched(sender: UITapGestureRecognizer) {
        profilePicEdited = true
        backgroundPicEdited = false
        let profilePicController = UIImagePickerController()
        profilePicController.navigationBar.tintColor = UIColor.blackColor()
        profilePicController.delegate = self
        profilePicController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(profilePicController, animated: true, completion: nil)
    }

    @IBAction func backgroundPicTouched(sender: UITapGestureRecognizer) {
        backgroundPicEdited = true
        profilePicEdited = false
        let backgroundPicController = UIImagePickerController()
        backgroundPicController.navigationBar.tintColor = UIColor.blackColor()
        backgroundPicController.delegate = self
        backgroundPicController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(backgroundPicController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if (profilePicEdited == true && backgroundPicEdited == false) {
            profileImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            profilePic = UIImageJPEGRepresentation(profileImage.image!, 1)
        }
        if (backgroundPicEdited == true && profilePicEdited == false) {
            backgroundImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            backgroundPic = UIImageJPEGRepresentation(backgroundImage.image!, 1)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveTouched(sender: AnyObject) {
        if (profilePic != nil) {
            let profileImageFile = PFFile(data: profilePic)
            profileImageFile?.saveInBackground()
            PFUser.currentUser()!["profilePic"] = profileImageFile
            PFUser.currentUser()?.saveInBackground()
            PFUser.currentUser()?.setObject(profileImageFile!, forKey: "profilePic")
            
        }
        if (backgroundPic != nil) {
            let backgroundImageFile = PFFile(data: backgroundPic)
            backgroundImageFile?.saveInBackground()
            PFUser.currentUser()!["backgroundPic"] = backgroundImageFile
            PFUser.currentUser()?.saveInBackground()
            PFUser.currentUser()?.setObject(backgroundImageFile!, forKey: "backgroundPic")
        }
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.labelText = "Updating Profile..."
        PFUser.currentUser()?.saveInBackgroundWithBlock{ (success: Bool, error: NSError?) -> Void in
            loadingNotification.hide(true)
            if (error != nil) {
                let alert = UIAlertController(title: "Alert", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            if (success) {
                let alert = UIAlertController(title: "Alert", message: "Profile Updated!", preferredStyle: UIAlertControllerStyle.Alert);
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) -> Void in
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        //self.profile.loadUserInfo()
                    })
                })
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelTouched(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
