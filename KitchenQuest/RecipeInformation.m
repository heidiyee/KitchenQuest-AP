//
//  RecipeInformation.m
//  KitchenQuest
//
//  Created by William Cremin on 12/14/15.
//  Copyright © 2015 William Cremin. All rights reserved.
//

#import "RecipeInformation.h"
#import "Recipe.h"

NSString *informationEndpointURL = @"https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes";

@implementation RecipeInformation

+ (void)getRecipeURLWithID:(NSString *)idNumber completion:(RecipeInfoCompletion)completion {
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/information", informationEndpointURL, idNumber];
    NSURL *urlForRequest = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlForRequest];
    [request addValue: [NSString stringWithFormat:@"%@", [Constants apiKey]] forHTTPHeaderField:@"X-Mashape-Key"];
    [[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *recipeInformation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSString *recipeInfoURL = recipeInformation[@"sourceUrl"];
        if (!error) {
            
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                completion(recipeInfoURL, nil);
            }];
            
        } else {
            
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                completion(nil, error);
            }];
            
        }
    }] resume];
}


@end
