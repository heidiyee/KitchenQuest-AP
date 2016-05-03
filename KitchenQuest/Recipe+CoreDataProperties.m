//
//  Recipe+CoreDataProperties.m
//  KitchenQuest
//
//  Created by William Cremin on 12/14/15.
//  Copyright © 2015 William Cremin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Recipe+CoreDataProperties.h"

@implementation Recipe (CoreDataProperties)

@dynamic title;
@dynamic imageURL;
@dynamic idNumber;
@dynamic likes;
@dynamic usedIngredientCount;
@dynamic missedIngredientCount;
@dynamic user;
@dynamic isSaved;

@end
