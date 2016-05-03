//
//  Recipe+CoreDataProperties.h
//  KitchenQuest
//
//  Created by William Cremin on 12/14/15.
//  Copyright © 2015 William Cremin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Recipe.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Recipe (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *imageURL;
@property (nullable, nonatomic, retain) NSString *idNumber;
@property (nullable, nonatomic, retain) NSNumber *likes;
@property (nullable, nonatomic, retain) NSNumber *usedIngredientCount;
@property (nullable, nonatomic, retain) NSNumber *missedIngredientCount;
@property (nullable, nonatomic, retain) User *user;
@property (nonatomic) BOOL isSaved;

@end

NS_ASSUME_NONNULL_END
