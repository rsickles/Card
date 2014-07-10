//
//  LoginViewController.h
//  Memify
//
//  Created by Ryan Sickles on 7/4/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController : UIViewController
{
    HomeViewController *homeViewController;
    RegisterViewController *registerViewController;
}
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
- (IBAction)login:(id)sender;
- (IBAction)signup:(id)sender;
@end
