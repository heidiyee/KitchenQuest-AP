//
//  SavedRecipesViewController.m
//  KitchenQuest
//
//  Created by William Cremin on 12/15/15.
//  Copyright © 2015 William Cremin. All rights reserved.
//

#import "SavedRecipesViewController.h"
#import "User.h"
#import "Recipe.h"
#import "KitchenTableViewCell.h"
#import "RecipeInformation.h"
#import "RecipeWebViewController.h"

@interface SavedRecipesViewController () <UITableViewDataSource, UITableViewDelegate, RecipeCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *savedRecipesTableView;
@property (strong, nonatomic) NSString *ingredientsForResults;
@property (weak, nonatomic) IBOutlet UILabel *noFavoriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *noSearchRecipesFound;

@end

@implementation SavedRecipesViewController

- (void)setRecipeDataSource:(NSMutableArray *)recipeDataSource {
    _recipeDataSource = recipeDataSource;
    [self.savedRecipesTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.noFavoriteLabel.hidden = YES;
    self.noSearchRecipesFound.hidden = YES;
    [self setupTableView];
    if ([self.restorationIdentifier isEqualToString:@"SavedRecipes"]) {
        
        NSArray *savedRecipes = [User fetchSavedRecipes];
        NSMutableArray *mutableDataSource = [NSMutableArray arrayWithArray:savedRecipes];
        NSLog(@"%@", mutableDataSource);
        if (mutableDataSource.count > 0) {
            [self setRecipeDataSource:mutableDataSource];
        } else {
            [self.recipeDataSource removeAllObjects];
            [self.savedRecipesTableView reloadData];
            self.noFavoriteLabel.hidden = NO;
        }
    }
    if ([self.restorationIdentifier isEqualToString:@"RecipeResults"]) {
        if (self.recipeDataSource.count == 0) {
            NSString *joinedComponents = [self.recipeIngredients componentsJoinedByString:@","];
            NSString *lowercaseJoined = [joinedComponents lowercaseString];
            self.ingredientsForResults = [lowercaseJoined stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            [Recipe fetchRecipesWithSearchTerms:self.ingredientsForResults completion:^(NSArray *result, NSError *error) {
                if (result) {
                    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:result];
                    
                    NSArray *newArray = [resultArray sortedArrayUsingDescriptors:@[
                        [NSSortDescriptor sortDescriptorWithKey:@"missedIngredientCount" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"usedIngredientCount" ascending:NO]]];
                    
//                    for (Recipe *recipe in newArray) {
//                        NSLog(@"%@", recipe.title);
//                        NSLog(@"%@ used", recipe.usedIngredientCount);
//                        NSLog(@"%@ missed", recipe.missedIngredientCount);
//                    }
                    
                    NSMutableArray *mutableNewArray = [NSMutableArray arrayWithArray:newArray];
                    if (mutableNewArray.count > 0) {
                        [self setRecipeDataSource:mutableNewArray];
                    } else {
                        self.noSearchRecipesFound.hidden = NO;

                    }
                    [self.savedRecipesTableView reloadData];
                }
                if (error) {
                    NSLog(@"%@", error);
                }
            }];
        } else {
//            NSLog(@"%@", self.recipeDataSource.description);
            [self.savedRecipesTableView reloadData];
        }
    }

}

- (void)setupTableView {
    self.savedRecipesTableView.delegate = self;
    self.savedRecipesTableView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"KitchenTableViewCell" bundle:nil];
    [self.savedRecipesTableView registerNib:nib forCellReuseIdentifier:@"KitchenTableViewCell"];
    self.savedRecipesTableView.rowHeight = 208.0;
    self.savedRecipesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.savedRecipesTableView.backgroundColor = [UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:0.6];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recipeDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KitchenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KitchenTableViewCell"];
    cell.delegate = self;
    cell.recipe = self.recipeDataSource[indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Recipe *selectedRecipe = self.recipeDataSource[indexPath.row];
    NSString *selectedID = [NSString stringWithFormat:@"%@", selectedRecipe.idNumber];
    
    RecipeWebViewController *webViewController = [[RecipeWebViewController alloc]init];
    webViewController.recipe = selectedRecipe;
    webViewController.recipeID = selectedID;
    
    [self.navigationController pushViewController:webViewController animated:YES];
}


#pragma mark - Recipe Cell Delegate

- (void)recipeCellDidRemove:(Recipe *)recipe {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Remove saved recipe" message:@"Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
  
            [recipe setIsSaved:NO];
            [[[CoreDataStack sharedStack]managedObjectContext]save:nil];
            [self.savedRecipesTableView reloadData];
            
            if ([self.restorationIdentifier isEqualToString:@"SavedRecipes"]) {
                [self.recipeDataSource removeObject:recipe];
                [self.savedRecipesTableView reloadData];
                if (self.recipeDataSource.count == 0) {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.noFavoriteLabel.hidden = NO;
                    }];
                }
            }

        }];
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:no];
        [alert addAction:yes];
        [self presentViewController:alert animated:YES completion:nil];
//    }
}

@end
