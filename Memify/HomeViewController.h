//
//  HomeViewController.h
//  Memify
//
//  Created by Ryan Sickles on 7/4/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "FormViewController.h"
#import "DropAnimationController.h"
#import <Parse/Parse.h>
@class LoginViewController;

@interface HomeViewController : UIViewController <NSURLConnectionDelegate,UIViewControllerTransitioningDelegate>
{
    NSMutableData *_imageData;
    LoginViewController *login;
}
- (IBAction)friendList:(id)sender;
- (IBAction) memeSend:(id)sender;
@property CGFloat boundsx;
@property CGFloat boundsy;
@property (nonatomic,strong) UIColor *mainColor;
@property (nonatomic,strong) NSString *boldFontName;
@property (strong, nonatomic) IBOutlet UIImageView *cardImage;
@property (strong, nonatomic) PFObject *firstImage;
@property (strong,nonatomic) NSString *userId;
@property NSInteger *active_state;
@property (nonatomic, retain) NSTimer *refreshTimer;

@property NSInteger *active_state;
@property (nonatomic, retain) NSTimer *refreshTimer;

@end
