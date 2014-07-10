//
//  LoginViewController.m
//  Memify
//
//  Created by Ryan Sickles on 7/4/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //make login button
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    float originx = ([UIScreen mainScreen].bounds.size.width/2) - 80;
    float originy = ([UIScreen mainScreen].bounds.size.height) - 50;
    loginButton.frame = CGRectMake(originx, originy, 160.0, 40.0);
    [self.view addSubview:loginButton];
    //log in button created and displayed to screen
    [PFFacebookUtils initializeFacebook];
    //check if user is already logged in with cache
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
        // Push the next view controller without animation
        home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
        [self.view addSubview:home.view];
    }
    //check if user is loggedin already with session
    
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // handle successful response
        } else if ([error.userInfo[FBErrorParsedJSONResponseKey][@"body"][@"error"][@"type"] isEqualToString:@"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"%@", error);
            NSLog(@"The facebook session was invalidated");
            [PFUser logOut]; // Log out
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
    //end of check
    
}

- (IBAction)login:(id)sender{
    NSArray *permissionsArray = @[ @"user_about_me"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        //activity indicator is for a spinny wheel when async call loading (class object)
        //[_activityIndicator stopAnimating]; // Hide loading indicator
        home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
        if (!user) {
            if (!error) {
                NSLog(@"%@", error);
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [self.view addSubview:home.view];
            
        } else {
            NSLog(@"User with facebook logged in!");
            [self.view addSubview:home.view];
        }
    }];
}


@end
