//
//  EditProfileViewController.swift
//  Recipes
//
//  Created by Lily on 4/4/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var profilePicEdited = false
    var backgroundPicEdited = false
    var profilePic: NSData!
    var backgroundPic: NSData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = PFUser.currentUser()?.username
        
        self.navigationItem.title = "Edit Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Bradley Hand", size: 30)!, NSForegroundColorAttributeName: UIColor.blackColor()]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func profilePicTouched(sender: UITapGestureRecognizer) {
        profilePicEdited = true
        backgroundPicEdited = false
        var profilePicController = UIImagePickerController()
        profilePicController.delegate = self
        profilePicController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(profilePicController, animated: true, completion: nil)
    }

    @IBAction func backgroundPicTouched(sender: UITapGestureRecognizer) {
        backgroundPicEdited = true
        profilePicEdited = false
        var backgroundPicController = UIImagePickerController()
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
            PFUser.currentUser()?.setObject(profileImageFile!, forKey: "profile_pic")
        }
        if (backgroundPic != nil) {
            let backgroundImageFile = PFFile(data: backgroundPic)
            PFUser.currentUser()?.setObject(backgroundImageFile!, forKey: "background_pic")
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
