//
//  ImageFetcherService.h
//  KitchenQuest
//
//  Created by Regular User on 12/14/15.
//  Copyright © 2015 William Cremin. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

typedef void (^kNSImageCompletionHandler)(UIImage *_Nullable data, NSError *_Nullable error);

@interface ImageFetcherService : NSObject

+ (void)fetchImageInBackgroundFromUrl:(nonnull NSURL *)url completionHandler:(nullable kNSImageCompletionHandler)completionHandler;

@end
