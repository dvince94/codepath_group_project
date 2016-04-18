//
//  TabBarViewController.swift
//  Recipes
//
//  Created by Vincent Duong on 4/16/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import SWRevealViewController

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        let profile = UIStoryboard(name: "Profile", bundle: nil)
        let recipe = UIStoryboard(name: "Recipes", bundle: nil)
        let challenge = UIStoryboard(name: "Challenge", bundle: nil)
        let favorite = UIStoryboard(name: "Favorite", bundle: nil)
        
        let profileNav = profile.instantiateViewControllerWithIdentifier("ProfileNavigationController") as! UINavigationController
        profileNav.tabBarItem.title = "Profile"
        
        let recipeNav = recipe.instantiateViewControllerWithIdentifier("RecipesContainerController") as! SWRevealViewController
        recipeNav.tabBarItem.title = "Recipe"
        
        let challengeNav = challenge.instantiateViewControllerWithIdentifier("ChallengeNavigationController") as! UINavigationController
        challengeNav.tabBarItem.title = "Challenge"
        
        let favoriteNav = favorite.instantiateViewControllerWithIdentifier("FavoriteNavigationController") as! UINavigationController
        favoriteNav.tabBarItem.title = "Favorite"
        self.viewControllers = [recipeNav, challengeNav, favoriteNav, profileNav]
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
