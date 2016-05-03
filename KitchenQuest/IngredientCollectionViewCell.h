//
//  IngredientCollectionViewCell.h
//  KitchenQuest
//
//  Created by Heidi Yee on 12/14/15.
//  Copyright © 2015 William Cremin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IngredientCollectionViewCellDelegate <NSObject>

- (void)ingredientCollectionViewCellDidDeleteIngredient:(NSString *)ingredient;

@end

@interface IngredientCollectionViewCell : UICollectionViewCell 

@property (weak, nonatomic) IBOutlet UILabel *ingredientLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) NSString *ingredient;
@property (weak, nonatomic) id<IngredientCollectionViewCellDelegate> delegate;

- (void)setIngredientLabel:(UILabel *)ingredientLabel;

@end
