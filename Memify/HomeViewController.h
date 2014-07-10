//
//  HomeViewController.h
//  Memify
//
//  Created by Ryan Sickles on 7/4/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
@class LoginViewController;

@interface HomeViewController : UIViewController <NSURLConnectionDelegate>
{
    NSMutableData *_imageData;
    LoginViewController *login;
}
- (IBAction)friendList:(id)sender;
- (IBAction) memeSend:(id)sender;
@end
