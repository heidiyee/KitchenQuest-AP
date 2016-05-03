//
//  IngredientAutocomplete.m
//  KitchenQuest
//
//  Created by William Cremin on 12/14/15.
//  Copyright © 2015 William Cremin. All rights reserved.
//

#import "IngredientAutocomplete.h"
#import "Recipe.h"

NSString *autocompleteEndpointURL = @"https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/food/ingredients/autocomplete";

@implementation IngredientAutocomplete

+ (void)autocompleteWithSearchTerm:(NSString *)term completion:(AutocompleteCompletion)completion {
    
    NSString *urlString = [NSString stringWithFormat:@"%@?query=%@", autocompleteEndpointURL, term];
    NSURL *urlForRequest = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlForRequest];
    
    [request addValue: [Constants apiKey] forHTTPHeaderField:@"X-Mashape-Key"];
    
    [[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil && data) {
            
            NSError *jsonError;
            NSArray *searchTerms = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            
            if (jsonError == nil && searchTerms) {
                NSInteger indexPath = 0;
                
                NSMutableArray *searchTermsToDisplay = [[NSMutableArray alloc]init];
                
                if (searchTerms.count >= 3) {
                    indexPath = 3;
                } else {
                    indexPath = searchTerms.count;
                }
                
                for (int x = 0; x < indexPath; x++) {
                    
                    NSDictionary *searchTerm = searchTerms[x];
                    NSString *name = searchTerm[@"name"];
                    
                    [searchTermsToDisplay addObject:name];
                }
                
                if (!error) {
                    
                    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                        completion(searchTermsToDisplay, nil);
                    }];
                    
                } else {
                    completion(nil, error);
                }
                
            } else {
                NSLog(@"%@", jsonError.localizedDescription);
            }
        }

    }] resume];
}

@end
