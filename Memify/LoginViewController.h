//
//  LoginViewController.h
//  Memify
//
//  Created by Ryan Sickles on 7/4/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
@class HomeViewController;

@interface LoginViewController : UIViewController
{
    HomeViewController *home;
}
- (IBAction)login:(id)sender;

@end
