//////
//////  RecipeResultsViewController.m
//////  KitchenQuest
//////
//////  Created by William Cremin on 12/15/15.
//////  Copyright © 2015 William Cremin. All rights reserved.
//////
////
////#import "RecipeResultsViewController.h"
////
////@interface RecipeResultsViewController ()
////
//
//#import "RecipeResultsViewController.h"
//#import "Recipe.h"
//
//@interface RecipeResultsViewController ()
//
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
//
//@property (strong, nonatomic) NSArray *recipeArray;
//
//@end
//
//@implementation RecipeResultsViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    UINib *nib = [UINib nibWithNibName:@"KitchenTableViewCell" bundle:nil];
//    [[self tableView] registerNib:nib forCellReuseIdentifier:@"KitchenTableViewCell"];
//    
//    //NSLog(@"%lu", self.recipeIngredients.count);
//    
//    //TEST FETCH RECIPE FROM API + SAVE TO CORE DATA
//    [Recipe fetchRecipesWithSearchTerms:@"tofu,broccoli,carrots" completion:^(NSArray *result, NSError *error) {
//        if (result) {
//            self.recipeArray = result;
//            for (Recipe *recipe in result) {
//                [User addSavedRecipesObject:recipe];
////                NSLog(@"%@", recipe.title);
////                NSLog(@"%@",recipe.missedIngredientCount);
////                NSLog(@"%@",recipe.usedIngredientCount);
//
//            }
//            
//            NSArray *newArray = [self.recipeArray sortedArrayUsingDescriptors:@[
//                                                            [NSSortDescriptor sortDescriptorWithKey:@"missedIngredientCount" ascending:YES],
//                                                            [NSSortDescriptor sortDescriptorWithKey:@"usedIngredientCount" ascending:NO]
//                                                            
//                                                            
//                                                            ]];
//            
//            for (Recipe *recipe in newArray) {
//                NSLog(@"%@", recipe.title);
//                NSLog(@"%@ used", recipe.usedIngredientCount);
//                NSLog(@"%@ missed", recipe.missedIngredientCount);
//            }
//        }
//        if (error) {
//            NSLog(@"%@", error);
//        }
//    }];
//    
//
//    
//
//}
//
//@end