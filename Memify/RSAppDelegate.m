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
    [IMGSession authenticatedSessionWithClientID:@"5da2629bc036a28" secret:@"09d5798e1c64bb06b20af9d6a353f65c91751a5e" authType:IMGCodeAuth withDelegate:self];
    //imgur authenticated
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
    //imgur stuff
    //app must register url scheme which starts the app at this endpoint with the url containing the code
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *param in [[url query] componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
    }
    
    NSString * pinCode = params[@"code"];
    
    if(!pinCode){
        NSLog(@"error: %@", params[@"error"]);
        
        self.continueHandler = nil;
        
        UIAlertView * a = [[UIAlertView alloc] initWithTitle:@"error" message:@"Access was denied by Imgur" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Try Again",nil];
        [a show];
        
        return NO;
    }
    
    [[IMGSession sharedInstance] authenticateWithCode:pinCode];
    
    if(_continueHandler)
        self.continueHandler();
    //end of imgur callback handling and we are good to go
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

#pragma Imgur delegate methods
-(void)imgurSessionNeedsExternalWebview:(NSURL *)url completion:(void (^)())completion{
    
    self.continueHandler = [completion copy];
    
    //go to safari to login, configure your imgur app to redirect to this app using URL scheme.
    [[UIApplication sharedApplication] openURL:url];
    
}

-(void)imgurSessionRateLimitExceeded{
    
    
}

@end
