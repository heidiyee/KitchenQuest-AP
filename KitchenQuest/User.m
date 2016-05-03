//
//  User.m
//  KitchenQuest
//
//  Created by William Cremin on 12/14/15.
//  Copyright © 2015 William Cremin. All rights reserved.
//

#import "User.h"
#import "Recipe.h"

@implementation User

+ (nullable NSArray *)fetchSavedRecipes {
    NSManagedObjectContext *context = [[CoreDataStack sharedStack]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    BOOL savedRecipe = YES;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSaved = %hhd", savedRecipe];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray *fetchedRecipes = [context executeFetchRequest:fetchRequest error:&error];
    NSArray *emptyArray = [[NSArray alloc]init];
    if ([fetchedRecipes isEqualToArray:emptyArray]) {
        NSLog(@"No recipes");
    } else {
        return fetchedRecipes;
    }
    return nil;
}

@end
