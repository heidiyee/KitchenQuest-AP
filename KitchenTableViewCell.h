//
//  KitchenTableViewCell.h
//  KitchenQuest
//
//  Created by Regular User on 12/14/15.
//  Copyright © 2015 William Cremin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@protocol RecipeCellDelegate <NSObject>

- (void)recipeCellDidRemove:(Recipe *)recipe;

@end

@interface KitchenTableViewCell : UITableViewCell

@property (strong, nonatomic) Recipe *recipe;
@property (weak, nonatomic) id <RecipeCellDelegate> delegate;

@end
