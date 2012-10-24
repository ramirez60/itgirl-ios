//
//  AppDelegate.h
//  itgirl
//
//  Created by gnamit on 10/13/12.
//  Copyright (c) 2012 gnamit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSingleton.h"
#import <Parse/Parse.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    DataSingleton *ds;
}
-(BOOL)load;
@property (nonatomic, retain) DataSingleton *ds;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
