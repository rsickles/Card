//
//  RSAppDelegate.m
//  Memify
//
//  Created by Ryan Sickles on 7/4/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "RSAppDelegate.h"

@implementation RSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [Parse setApplicationId:@"vKfmLUoNUcwcrkUMU2rFIvZTg0ujLH0LuzxpeHdW" clientKey:@"02wLqKIDArw4J1G1F555FfA35QSCk9IYzJCaquOu"];
    [PFFacebookUtils initializeFacebook];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    self.window.backgroundColor = [UIColor whiteColor];
    //set loginViewController as the root view controller
    loginViewController = [[LoginViewController alloc]initWithNibName:nil bundle:nil];
    loginViewController.title = @"MemeCard";
    navController = [[UINavigationController alloc]initWithRootViewController:loginViewController];
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
    
    // You can add your app-specific url handling code here if needed
    return wasHandled;
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
}

@end
