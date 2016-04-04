//
//  AddChallengeViewController.swift
//  Recipes
//
//  Created by Kevin Duong on 3/29/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit

class AddChallengeViewController: UIViewController, UITextViewDelegate  {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsTextView.text = "Ingredient 1\nIngredient 2\netc.."
        ingredientsTextView.textColor = UIColor.lightGrayColor()
        
        descriptionTextView.text = "Add description here."
        descriptionTextView.textColor = UIColor.lightGrayColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark Save and Cancel
    
    @IBAction func cancelButtonTapped(sender: AnyObject){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        if (containText(titleTextField.text!) == false) {
            showAlertMessage("No Title Added", messages: "Please add a title.")
        }
        else if (containText(ingredientsTextView.text!) == false || ingredientsTextView.textColor == UIColor.lightGrayColor()) {
            showAlertMessage("No Ingredients Added", messages: "Please add an ingredient.")
        }
        else if (containText(descriptionTextView.text!) == false || descriptionTextView.textColor == UIColor.lightGrayColor()) {
            showAlertMessage("No Descripions Added", messages: "Please add a description.")
        }
        else {
            let ingredients = parseIngredients(ingredientsTextView.text!)
            //Post challenge
            Challenge.postChallenge(title: titleTextField.text!, withIngredients: ingredients, withDescription: descriptionTextView.text!, withCompletion: { (success, error) -> Void in
                if success == true {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else {
                    print("\(error?.localizedDescription)")
                }
            })
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
    
    //Parse ingredients
    func parseIngredients(str: String) -> [String] {
        let newLineChars = NSCharacterSet.newlineCharacterSet()
        let ingredients =  str.componentsSeparatedByCharactersInSet(newLineChars)
        //filter out empty strings
        return ingredients.filter(){$0 != ""}
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
    
    //MARK: - TextView Handling Method
    
    func textViewDidBeginEditing(textView: UITextView) {
        //Get rid of placeholder
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        //Replace placeholder if text is empty
        if containText(ingredientsTextView.text!) == false {
            textView.text = "Ingredient 1\nIngredient 2\netc.."
            textView.textColor = UIColor.lightGrayColor()
        }
        if containText(descriptionTextView.text!) == false {
            textView.text = "Add description here."
            textView.textColor = UIColor.lightGrayColor()
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
