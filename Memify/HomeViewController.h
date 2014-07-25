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
#import "CardView.h"
@class LoginViewController;

@interface HomeViewController : UIViewController <NSURLConnectionDelegate,UIViewControllerTransitioningDelegate,MDCSwipeToChooseDelegate>
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
@property (strong, nonatomic) PFObject *firstImage;
@property (strong,nonatomic) NSString *userId;
@property (strong,nonatomic) NSNumber *active_state;
@property (strong,nonatomic) NSNumber *flipped;
//card properties
@property (nonatomic, strong) Card *currentCard;
@property (nonatomic, strong) CardView *frontCardView;
@property (nonatomic, strong) CardView *backCardView;
@end
