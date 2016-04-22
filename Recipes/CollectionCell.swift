//
//  CollectionCell.swift
//  Recipes
//
//  Created by Vincent Duong on 4/17/16.
//  Copyright © 2016 CodepathGroupProject. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class CollectionCell: UICollectionViewCell {
    @IBOutlet weak var recipeImage: PFImageView!
    @IBOutlet weak var recipeName: UILabel!
    
    var recipe: Post! {
        didSet {
            //Cancel connection to task
            self.recipeImage.file = recipe.imageFile
            self.recipeImage.loadInBackground()
            recipeName.text = recipe.title
            
            self.layer.cornerRadius = 10.0
            self.clipsToBounds = true
        }
    }

    
}
