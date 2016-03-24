//
//  RecipeDetailViewController.swift
//  Recipes
//
//  Created by Lily on 3/22/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var directionsLabel: UILabel!
    
    var recipe: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientsLabel.text = Recipe.printIngredients(recipe["ingredients"] as! [String])
        directionsLabel.text = printDirections(recipe["directions"] as! [String])
        // Do any additional setup after loading the view.
    }
    
    func printDirections(string: [String]) -> String {
        var directionsPrint = ""
        let directions = string;
        
        for index in 0...(directions.count - 1) {
            
            directionsPrint += "Step\(index)" + directions[index] + "\n"
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
