//
//  SavedRecipesViewController.h
//  KitchenQuest
//
//  Created by William Cremin on 12/15/15.
//  Copyright © 2015 William Cremin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedRecipesViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *recipeDataSource;
@property (strong, nonatomic) NSArray *recipeIngredients;

@end
