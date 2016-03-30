//
//  RecipeDetailViewController.swift
//  Recipes
//
//  Created by Lily on 3/22/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var recipeImage: PFImageView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var directionsLabel: UILabel!
    
    var recipe: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientsLabel.text = Recipe.printIngredients(recipe["ingredients"] as! [String])
        directionsLabel.text = Recipe.printDirections(recipe["directions"] as! [String])
        self.recipeImage.file = recipe["image"] as? PFFile
        self.recipeImage.loadInBackground()
        // puts title on navigation bar..changes size, color, and font of title
        self.navigationItem.title = recipe["title"] as? String
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Papyrus", size: 30)!, NSForegroundColorAttributeName: UIColor.blackColor()]
        // Do any additional setup after loading the view.
        directionsLabel.preferredMaxLayoutWidth = directionsLabel.frame.size.width
    }
    
    /*
     * Method that gets the directions to be put on the view
     */
    func printDirections(string: [String]) -> String {
        var directionsPrint = ""
        let directions = string;
        
        for index in 0...(directions.count - 1) {
            
            directionsPrint += "Step \(index + 1). " + directions[index] + "\n"
        }
        
        return directionsPrint
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
