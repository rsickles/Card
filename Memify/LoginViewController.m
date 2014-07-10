//
//  LoginViewController.m
//  Memify
//
//  Created by Ryan Sickles on 7/4/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize homeViewController;
@synthesize registerViewController;

//instantiates view controller
-(HomeViewController *)homeViewController{
    if(!homeViewController){
        homeViewController = [[HomeViewController alloc]initWithNibName:nil bundle:nil];
        homeViewController.title = @"Memify";
    }
    return homeViewController;
}
//instantiates view controller
-(RegisterViewController *)registerViewController{
    if(!registerViewController){
        registerViewController = [[RegisterViewController alloc]initWithNibName:nil bundle:nil];
        registerViewController.title = @"Register";
    }
    return registerViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)login:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([username length] == 0 || [password length] == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Some fields are incomplete" delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else{
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error){
            if(error){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil];
                [alert show];
            }
            else{
                [self.navigationController pushViewController:self.homeViewController animated:YES];
                //go to root home controller
            }
        }];
    }
}
- (IBAction)signup:(id)sender {
    [self.navigationController pushViewController:self.registerViewController animated:YES];
}
@end
