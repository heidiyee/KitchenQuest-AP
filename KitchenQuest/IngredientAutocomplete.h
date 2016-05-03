//
//  IngredientAutocomplete.h
//  KitchenQuest
//
//  Created by William Cremin on 12/14/15.
//  Copyright © 2015 William Cremin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

typedef void(^AutocompleteCompletion)(NSArray *_Nullable result, NSError *_Nullable error);

@interface IngredientAutocomplete : NSObject

+ (void)autocompleteWithSearchTerm:(nonnull NSString *)term completion:(nullable AutocompleteCompletion)completion;

@end
