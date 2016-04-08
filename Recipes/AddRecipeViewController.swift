//
//  AddRecipeViewController.swift
//  Recipes
//
//  Created by Vincent Duong on 3/23/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse

class AddRecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var selectedTag: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var directionsTextView: UITextView!

    
    let imagePicker = UIImagePickerController()
    var editedImage: UIImage?
    var imageChanged = false
    
    var isChallenge: Bool!
    var challenge_id: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.navigationBar.tintColor = UIColor.blackColor()
        
        //Enable user interaction
        imageView.userInteractionEnabled = true
        //add a tap gesture recognizer to the image view
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
        //Add the recognizer to your view.
        imageView.addGestureRecognizer(tapRecognizer)
        
        descriptionTextView.text = "Add description here."
        descriptionTextView.textColor = UIColor.lightGrayColor()
        
        ingredientsTextView.text = "Ingredient 1\nIngredient 2\netc.."
        ingredientsTextView.textColor = UIColor.lightGrayColor()
        
        directionsTextView.text = "Step 1\nStep 2\netc..."
        directionsTextView.textColor = UIColor.lightGrayColor()
        
        selectedTag.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //When canceled is tapped, dismiss the view controller
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Save Button Tapped
    @IBAction func saveButtonTapped(sender: AnyObject) {
        if (imageChanged == false && !(isChallenge!)) {
            showAlertMessage("No Image Selected", messages: "Please add an image.")
        }
        else if (containText(titleTextField.text!) == false) {
            showAlertMessage("No Title Added", messages: "Please add a title.")
        }
        else if (containText(descriptionTextView.text!) == false || descriptionTextView.textColor == UIColor.lightGrayColor()) {
            showAlertMessage("No Descriptions Added", messages: "Please add a description.")
        }
        else if (containText(ingredientsTextView.text!) == false || ingredientsTextView.textColor == UIColor.lightGrayColor()) {
            showAlertMessage("No Ingredients Added", messages: "Please add an ingredient.")
        }
        else if (containText(directionsTextView.text!) == false || directionsTextView.textColor == UIColor.lightGrayColor()) {
            showAlertMessage("No Directions Added", messages: "Please add a direction.")
        }
        else {
            let ingredients = parseIngredients(ingredientsTextView.text!)
            let directions = parseDirections(directionsTextView.text!)
            //Post recipe
            let post = Post();
            post.title = titleTextField.text
            post.descriptions = descriptionTextView.text
            post.ingredients = ingredients
            post.directions = directions
            post.tag = selectedTag.text
            
            if (imageChanged == false) {
                editedImage = UIImage(named:"Hangry_Dark.png")
                print(challenge_id)
                post.challenge_id = challenge_id!
            } else {
                post.challenge_id = "0"
            }
            post.image = editedImage
            
            post.uploadPost()
            dismissViewControllerAnimated(true, completion: nil)
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
    
    
    //Parse directions
    func parseDirections(str: String) -> [String] {
        let newlineChars = NSCharacterSet.newlineCharacterSet()
        let directions = str.componentsSeparatedByCharactersInSet(newlineChars)
        return directions.filter(){$0 != ""}
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
    ----------------------------
    MARK: - Tag Selection Method
    ----------------------------
    */
    
    @IBAction func selectButtonTapped(sender: UIButton) {
        let alertController = UIAlertController(title: "Choose Tag", message: nil, preferredStyle: .ActionSheet)
        
        //Select Cancel
        let breakfast = UIAlertAction(title: "Breakfast", style: UIAlertActionStyle.Default) {
            (action) in
            self.selectedTag.text = "Breakfast"
        }
        
        //Select lunch
        let lunch = UIAlertAction(title: "Lunch", style: UIAlertActionStyle.Default) {
            (action) in
            self.selectedTag.text = "Lunch"
        }
        
        //Select dinner
        let dinner = UIAlertAction(title: "Dinner", style: UIAlertActionStyle.Default) {
            (action) in
            self.selectedTag.text = "Dinner"
        }
        
        //Select lunch
        let dessert = UIAlertAction(title: "Dessert", style: UIAlertActionStyle.Default) {
            (action) in
            self.selectedTag.text = "Dessert"
        }
        
        //Select dinner
        let snack = UIAlertAction(title: "Snack", style: UIAlertActionStyle.Default) {
            (action) in
            self.selectedTag.text = "Snack"
        }
        
        
        
        //Create an Cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .Default) { (action) in
            self.selectedTag.text = ""
        }
        
        //Add created actions to the alert controller
        alertController.addAction(breakfast)
        alertController.addAction(lunch)
        alertController.addAction(dinner)
        alertController.addAction(dessert)
        alertController.addAction(snack)
        alertController.addAction(cancel)
        
        //Present view controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    /*
    --------------------------------
    MARK: - TextView Handling Method
    --------------------------------
    */
    
    func textViewDidBeginEditing(textView: UITextView) {
        //Get rid of placeholder
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        //Replace placeholder if text is empty
        if !containText(descriptionTextView.text!) {
            textView.text = "Add description here."
            textView.textColor = UIColor.lightGrayColor()
        }
        if containText(ingredientsTextView.text!) == false {
            textView.text = "Ingredient 1\nIngredient 2\netc.."
            textView.textColor = UIColor.lightGrayColor()
        }
        if containText(directionsTextView.text!) == false {
            textView.text = "Step 1\nStep 2\netc..."
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        if (textView == ingredientsTextView) {
//            if (text == "\n") {
//                if range.location == textView.text.characters.count {
//                    let updatedText: String = textView.text!.stringByAppendingString("\n\u{2022} ")
//                    textView.text = updatedText
//                }
//                else {
//                    let beginning: UITextPosition = textView.beginningOfDocument
//                    let start: UITextPosition = textView.positionFromPosition(beginning, offset: range.location)!
//                    let end: UITextPosition = textView.positionFromPosition(start, offset: range.length)!
//                    let textRange: UITextRange = textView.textRangeFromPosition(start, toPosition: end)!
//                    textView.replaceRange(textRange, withText: "\n\u{2022} ")
//                    let cursor: NSRange = NSMakeRange(range.location + "\n\u{2022} ".length, 0)
//                    textView.selectedRange = cursor
//                }
//                return false
//            }
//        }
//        return true
//    }
    
    /*
    -----------------------------
    MARK: - Image Handling Method
    -----------------------------
    */
    
    //Choose image from photo library or take picture
    //Guide taken from http://www.theappguruz.com/blog/user-interaction-camera-using-uiimagepickercontroller-swift
    func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .ActionSheet)
        
        //Create camera action
        let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
            (action) in
            self.takePicture()
        }
        
        //Create photo library action
        let choosePhoto = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) {
            (action) in
            self.choosePicture()
        }
        
        //Create an Cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .Default) { (action) in
            //Do nothing
        }
        
        //Add created actions to the alert controller
        alertController.addAction(camera)
        alertController.addAction(choosePhoto)
        alertController.addAction(cancel)
        
        //Present view controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //Opens the camera
    func takePicture() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        else {
            showAlertMessage("No Camera", messages: "Sorry, this device has no camera.")
        }
    }
    
    //Opens the photo library
    func choosePicture() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        else {
            showAlertMessage("No Photo Library", messages: "Sorry, this device has no photo library.")
        }
    }
    
    //Image picker controller delegate methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Change image to selected image
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
        }
        
        // Get the image captured by the UIImagePickerController and resize it before saving
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // Get half the size of the image
        let size = CGSize(width: originalImage.size.width / 3, height: originalImage.size.height / 3)
        editedImage = resize(originalImage, newSize: size)
        imageChanged = true
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //If canceled clicked, dismiss the view controller.
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Resize the image to make it use less memory
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
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
