//
//  RSAppDelegate.h
//  Memify
//
//  Created by Ryan Sickles on 7/4/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "ImgurSession.h"

@interface RSAppDelegate : UIResponder <UIApplicationDelegate,IMGSessionDelegate>
{
    UINavigationController *navController;
    LoginViewController *loginViewController;
}
@property (strong, nonatomic) UIWindow *window;
@property (copy) void(^continueHandler)();
@end
