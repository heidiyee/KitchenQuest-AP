//
//  RecipeInformation.h
//  KitchenQuest
//
//  Created by William Cremin on 12/14/15.
//  Copyright © 2015 William Cremin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

typedef void(^RecipeInfoCompletion)(NSString *_Nullable result, NSError *_Nullable error);

@interface RecipeInformation : NSObject

+ (void)getRecipeURLWithID:(nonnull NSString *)idNumber completion:(nullable RecipeInfoCompletion)completion;

@end
