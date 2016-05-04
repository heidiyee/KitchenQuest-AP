//
//  AppDelegate.h
//  KitchenQuest
//
//  Created by William Cremin on 12/14/15.
//  Copyright © 2015 William Cremin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TAGContainerOpener.h"



@class TAGManager;
@class TAGContainer;

@interface AppDelegate : UIResponder <UIApplicationDelegate, TAGContainerOpenerNotifier>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TAGManager *tagManager;
@property (strong, nonatomic) TAGContainer *container;

@end
