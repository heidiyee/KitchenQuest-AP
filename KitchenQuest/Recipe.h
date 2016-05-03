//
//  Recipe.h
//  KitchenQuest
//
//  Created by William Cremin on 12/14/15.
//  Copyright © 2015 William Cremin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Recipe.h"
#import "User.h"
#import "Constants.h"
#import "CoreDataStack.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SearchCompletion)(NSArray *_Nullable result,  NSError *_Nullable error);

@interface Recipe : NSManagedObject

+ (void)fetchRecipesWithSearchTerms:(NSString *)terms completion:(SearchCompletion)completion;

@end

NS_ASSUME_NONNULL_END

#import "Recipe+CoreDataProperties.h"
