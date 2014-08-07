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
#import "GlobalVariables.h"

@interface LoginViewController ()
@end
@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setGlobals];
    [self createBackgroundImage];
    [self createLoginButton];
    [PFFacebookUtils initializeFacebook];
    [self checkIfUserAlreadyLoggedInCache];
}

-(void)setGlobals
{
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
}

-(void)checkIfUserAlreadyLoggedInCache
{
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
    {
        home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
        [self.view addSubview:home.view];
    }
}

-(void)createBackgroundImage
{
    CGRect rect = CGRectMake(0,0,screenWidth,screenHeight);
    UIGraphicsBeginImageContext( rect.size );
    [[UIImage imageNamed:@"Card-Screen"] drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(picture1);
    UIImage *img=[UIImage imageWithData:imageData];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:img]];
}

-(void)createLoginButton
{
    //set login button
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"SIGN-IN.png"] forState:UIControlStateNormal];
    float originx = (screenWidth/2) - 132;
    float originy = (screenHeight) - 205;
    loginButton.frame = CGRectMake(originx, originy, 265.0, 66.0);
    [self.view addSubview:loginButton];
}

- (IBAction)login:(id)sender{
    NSArray *permissionsArray = @[ @"user_about_me",@"public_profile", @"user_friends" ];
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
        if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            // After logging in with Facebook
            FBRequest *request = [FBRequest requestForMe];
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error)
                {
                    NSDictionary *userData = (NSDictionary *)result;
                    NSString *first_name = userData[@"first_name"];
                    NSString *last_name = userData[@"last_name"];
                    NSString *gender = userData[@"gender"];
                    [user setObject:[NSString stringWithString:first_name]forKey:@"first_name"];
                    [user setObject:[NSString stringWithString:last_name] forKey:@"last_name"];
                    [user setObject:[NSString stringWithString:gender] forKey:@"gender"];
                    [user setObject:[NSString stringWithString:userData[@"id"]] forKey:@"facebook_id"];
                    [user saveInBackground];
                }
            }];
            [self.view addSubview:home.view];
        } else {
            NSLog(@"User with facebook logged in!");
            [self.view addSubview:home.view];
        }
    }];
}
@end
