//
//  LoginViewController.swift
//  Recipes
//
//  Created by Kevin Duong on 3/16/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//


/* ******* Made one user account *******
 * Username: Admin
 * Password: password
 */

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginButton.layer.cornerRadius = 10
        signUpButton.layer.cornerRadius = 10
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        if containText(usernameField.text!) == true {
            // initialize a user object
            let newUser = PFUser()
            
            // set user properties
            newUser.username = usernameField.text
            newUser.password = passwordField.text
            
            // call sign up function on the object
            newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if success {
                    print("Yay, created a user!")
                    self.performSegueWithIdentifier("loginSegue", sender: nil)
                } else {
                    print(error?.localizedDescription)
                    if error?.code == 202 {
                        self.showAlertMessage("Sign Up Error", messages: "Username taken")
                        print("User name is taken")
                    }
                    else {
                        self.showAlertMessage("Login Error", messages: "\(error!.localizedDescription)")
                    }
                }
            }
        }
        else {
            showAlertMessage("Sign Up Error", messages: "Please add an username and password.")
        }
    }
    
    //Check if it contains any text
    func containText(str: String) -> Bool {
        let whiteSpaceSet = NSCharacterSet.whitespaceCharacterSet()
        if str.stringByTrimmingCharactersInSet(whiteSpaceSet) != "" {
            return true
        }
        return false
    }
    
    @IBAction func onSignIn(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("you're logged in!")
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            }
            else {
                self.showAlertMessage("Login Error", messages: "\(error!.localizedDescription)")
            }
        }
    }
    
    //Show error message
    func showAlertMessage(titles: String, messages: String) {
        let alertController = UIAlertController(title: "\(titles)", message: "\(messages)", preferredStyle: .Alert)
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        
        presentViewController(alertController, animated: true) {
            // optional code for what happens after the alert controller has finished presenting
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
