//
//  SeachIngredientsCollectionViewController.m
//  KitchenQuest
//
//  Created by Heidi Yee on 12/15/15.
//  Copyright © 2015 William Cremin. All rights reserved.
//

#import "SeachIngredientsCollectionViewController.h"
#import "Recipe.h"
#import "IngredientAutocomplete.h"
#import "RecipeInformation.h"
#import "User.h"
#import "IngredientCollectionViewCell.h"
#import "SavedRecipesViewController.h"


@import QuartzCore;

NSInteger const kNumberOfColumns = 1;
NSInteger const kNumberOfRows = 8;
CGFloat const kCornerRadius = 4;
CGFloat const kButtonCornerRadius = 8.0;
CGFloat const kSegmentedControlHeight = 30;
CGFloat const kCellHeight = 40;

@interface SeachIngredientsCollectionViewController () <UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, IngredientCollectionViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *ingredients;
@property (strong, nonatomic) NSMutableArray *searchIngredients;
@property (weak, nonatomic) IBOutlet UITextView *ingredientsTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *ingredientCollectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ingredientSegmentControl;
@property (weak, nonatomic) IBOutlet UIButton *imHungryButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentedControlHeightConstraint;
//@property (nonatomic) UIInterfaceOrientation orientation;

@end

@implementation SeachIngredientsCollectionViewController

- (void)setIngredients:(NSMutableArray *)ingredients {
    _ingredients = ingredients;
    
    [self.ingredientCollectionView reloadData];
}

-(void)setSearchIngredients:(NSMutableArray *)searchIngredients {
    _searchIngredients = searchIngredients;
    
    [self.ingredientSegmentControl reloadInputViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ingredientsTextView.delegate = self;
    self.ingredientsTextView.layer.borderWidth = 1.0f;
    self.ingredientsTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.ingredientsTextView.layer.cornerRadius = kCornerRadius;
    self.ingredients = [[NSMutableArray alloc]init];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.searchIngredients = [[NSMutableArray alloc]init];
    [self setupSegmentControl];
    self.segmentedControlHeightConstraint.constant = 0;
    [self.ingredientSegmentControl updateConstraintsIfNeeded];
    self.ingredientSegmentControl.layer.cornerRadius = kCornerRadius;
    
    self.imHungryButton.layer.cornerRadius = kButtonCornerRadius;
    self.imHungryButton.alpha = 0.95;
    
    self.ingredientCollectionView.backgroundColor = [UIColor clearColor];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Ingredients"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.orientation = [UIApplication sharedApplication].statusBarOrientation;
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged)  name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    //NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: UIDeviceOrientationDidChangeNotification, object: nil)

}

-(void)hideKeyBoard {
    [self.view endEditing:YES];
//    [UIView animateWithDuration:0 animations:^{
//        self.segmentedControlHeightConstraint.constant = 0;
//        [self.view layoutIfNeeded];
//    }];
}

-(void)orientationChanged {
    [self.ingredientCollectionView reloadData];
}

#pragma mark - text view delegate


- (void)textViewDidChange:(UITextView *)textView {
    self.ingredientSegmentControl.selectedSegmentIndex = -1;

    //TEST AUTOCOMPLETE FROM API FOR SEARCH
    [IngredientAutocomplete autocompleteWithSearchTerm:[NSString stringWithFormat:@"%@", textView.text] completion:^(NSArray *result, NSError *error) {
        if (result) {
            [self.searchIngredients removeAllObjects];
            [self.searchIngredients addObjectsFromArray:result];
            [self setupSegmentControl];
        }
        if (error) {
            NSLog(@"%@", error);
        }
    }];
    
    if ([textView.text containsString:@"\n"]) {
        NSString *ingredientString = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (ingredientString.length > 1) {
            if (![self.ingredients containsObject:[NSString stringWithFormat:@"%@",ingredientString]]) {
                [self.ingredients addObject:[NSString stringWithFormat:@"%@",ingredientString]];
                [self.ingredientCollectionView reloadData];
                NSInteger section = [self.ingredientCollectionView numberOfSections] - 1 ;
                NSInteger item = [self.ingredientCollectionView numberOfItemsInSection:section] - 1 ;
                NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
                if (self.ingredients.count > 0) {
                    [self.ingredientCollectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:(UICollectionViewScrollPositionBottom) animated:YES];
                }
            } else {
                NSLog(@"already have that ingredient");
            }
        }
        self.ingredientsTextView.text = @"";
        //[textView resignFirstResponder];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.segmentedControlHeightConstraint.constant = kSegmentedControlHeight;
        [self.view layoutIfNeeded];
    }];
}


#pragma mark - Collection View Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.ingredients.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IngredientCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IngredientCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.ingredient = self.ingredients[indexPath.row];
    cell.contentView.backgroundColor = [UIColor colorWithRed:0.34 green:0.74 blue:0.94 alpha:1.0];
    cell.contentView.alpha = 0.95;
    cell.contentView.layer.cornerRadius = kButtonCornerRadius;
    return cell;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 4.0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat boundsWidth = self.ingredientCollectionView.frame.size.width;

    CGFloat cellSizeWidth = ((boundsWidth / kNumberOfColumns) - 4);
    
    return CGSizeMake(cellSizeWidth, kCellHeight);
}


#pragma mark - Custom Cell Delegate

- (void)ingredientCollectionViewCellDidDeleteIngredient:(NSString *)ingredient {
    NSLog(@"%@", ingredient);
    
    [self.ingredients removeObject:ingredient];
    [self.ingredientCollectionView reloadData];
}

- (IBAction)hungryButtonSelected:(UIButton *)sender {
    if (self.ingredients.count == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add Ingredient" message:@"If you don't have any ingredients, you might starve..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
      //
    }
}


#pragma mark - segment control

- (void)setupSegmentControl {
    NSInteger indexPath = 0;
    [self.ingredientSegmentControl setTitle:@"" forSegmentAtIndex:0];
    [self.ingredientSegmentControl setTitle:@"" forSegmentAtIndex:1];
    [self.ingredientSegmentControl setTitle:@"" forSegmentAtIndex:2];
    
    if (self.searchIngredients.count > 0) {
        for (NSString *ingredient in self.searchIngredients) {
            [self.ingredientSegmentControl setTitle:ingredient forSegmentAtIndex:indexPath];
            indexPath ++;
        }
    } 
}

- (IBAction)ingredientSegmentControlSelected:(UISegmentedControl *)sender {
    NSString *name = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    if (name.length > 0) {
        if (![self.ingredients containsObject:[NSString stringWithFormat:@"%@",name]]) {
            [self.ingredients addObject:[NSString stringWithFormat:@"%@",name]];
            [self.ingredientCollectionView reloadData];
            self.ingredientsTextView.text = @"";
            NSInteger section = [self.ingredientCollectionView numberOfSections] - 1 ;
            NSInteger item = [self.ingredientCollectionView numberOfItemsInSection:section] - 1 ;
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
            if (self.ingredients.count > 0) {
                [self.ingredientCollectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:(UICollectionViewScrollPositionBottom) animated:YES];
            }

        } else {
            NSLog(@"already have that ingredient");
        }
    }
}


#pragma mark - segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RecipeResults"]) {
        if ([sender isKindOfClass:[UIButton class]]) {
            SavedRecipesViewController *recipeResultsVC = (SavedRecipesViewController *)segue.destinationViewController;

            recipeResultsVC.recipeIngredients = self.ingredients;

        }
    }
}


@end
