//
//  RecipeWebViewController.h
//  KitchenQuest
//
//  Created by William Cremin on 12/14/15.
//  Copyright © 2015 William Cremin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface RecipeWebViewController : UIViewController

@property (copy, nonatomic) NSString *recipeID;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) Recipe *recipe;

@end
