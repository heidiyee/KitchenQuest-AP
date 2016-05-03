//
//  ImageFetcherService.m
//  KitchenQuest
//
//  Created by Regular User on 12/14/15.
//  Copyright © 2015 William Cremin. All rights reserved.
//

#import "ImageFetcherService.h"
#import "Constants.h"

@implementation ImageFetcherService

+ (void)fetchImageInBackgroundFromUrl:(NSURL *)url completionHandler:(kNSImageCompletionHandler)completionHandler {
    
    dispatch_queue_t imageQueue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    dispatch_async(imageQueue, ^{
        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL:url options: NSDataReadingUncached error:&error];
        
        if (data) {
            UIImage *result = [[UIImage alloc] initWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil && data != nil){
                    completionHandler(result, nil);
                    return;
                }
                
                if( error == nil && data == nil){
                    NSError *error = [NSError errorWithDomain:@"Error: Image is nil" code:-1 userInfo:nil];
                    completionHandler(nil, error);
                    return;
                }
                
                completionHandler(nil, error);
            });
        } else {
            return;
        }
    });
}

@end
