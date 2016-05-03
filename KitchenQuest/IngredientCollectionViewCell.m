//
//  IngredientCollectionViewCell.m
//  KitchenQuest
//
//  Created by Heidi Yee on 12/14/15.
//  Copyright © 2015 William Cremin. All rights reserved.
//

#import "IngredientCollectionViewCell.h"


@implementation IngredientCollectionViewCell

- (void)setIngredient:(NSString *)ingredient {
    

    _ingredient = ingredient;
    
    // ...
    [self.ingredientLabel setText:_ingredient];
    self.cancelButton.layer.cornerRadius = 8.0;
    self.backgroundColor = [UIColor clearColor];


}

- (IBAction)deleteButtonSelected:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate ingredientCollectionViewCellDidDeleteIngredient:self.ingredient];
    }
}

@end
