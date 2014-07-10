//
//  HomeViewController.h
//  Memify
//
//  Created by Ryan Sickles on 7/4/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsViewController.h"
#import "LoginViewController.h"
@class LoginViewController;
@class FriendsViewController;

@interface HomeViewController : UIViewController <NSURLConnectionDelegate>
{
    NSMutableData *_imageData;
    LoginViewController *login;
    FriendsViewController *friendsPage;
}
- (IBAction)friendList:(id)sender;
- (IBAction) memeSend:(id)sender;
@end
