//
//  KitchenTableViewCell.m
//  KitchenQuest
//
//  Created by Regular User on 12/14/15.
//  Copyright © 2015 William Cremin. All rights reserved.
//

#import "KitchenTableViewCell.h"
#import "ImageFetcherService.h"
#import "Constants.h"
#import "User.h"

@interface KitchenTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *recipeNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImageView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation KitchenTableViewCell

- (void)setRecipe:(Recipe *)recipe {
    _recipe = recipe;
    self.recipeNameLabel.text = recipe.title;
    if (recipe.isSaved) {
        [self.saveButton setImage:[UIImage imageNamed:@"heartFill.png"] forState:UIControlStateNormal];
    } else {
        [self.saveButton setImage:[UIImage imageNamed:@"heartNoFill.png"] forState:UIControlStateNormal];
    }
    
    NSArray *savedRecipes = [User fetchSavedRecipes];
    for (Recipe *savedRecipe in savedRecipes) {
        if ([recipe.idNumber isEqualToString:savedRecipe.idNumber]) {
            recipe.isSaved = YES;
        }
    }
    
    if (recipe.imageURL != nil) {
        NSURL *imageURL = [NSURL URLWithString:recipe.imageURL];
        [ImageFetcherService fetchImageInBackgroundFromUrl:imageURL completionHandler:^(UIImage * _Nullable data, NSError * _Nullable error) {
            if (data) {
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    self.recipeImageView.image = data;
                    [self.recipeImageView.layer setCornerRadius:20.0];
                }];
            }
            if (error) {
                NSLog(@"%@", error);
            }
        }];
    }
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    if (self.recipe.isSaved) {
        [self.recipe setIsSaved:NO];
        [[[CoreDataStack sharedStack]managedObjectContext]save:nil];
        if (self.delegate) {
            [self.delegate recipeCellDidRemove:self.recipe];
        }
    } else {
        [self.saveButton setImage:[UIImage imageNamed:@"heartFill.png"] forState:UIControlStateNormal];
        [self.recipe setIsSaved:YES];
        [[[CoreDataStack sharedStack]managedObjectContext]save:nil];
    }
}

@end
