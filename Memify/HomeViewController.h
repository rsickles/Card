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

@interface HomeViewController : UIViewController <NSURLConnectionDelegate,UIViewControllerTransitioningDelegate,MDCSwipeToChooseDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableData *_imageData;
    LoginViewController *login;
}
- (void)retrieveCards;
@property (nonatomic,strong) UIColor *mainColor;
@property (nonatomic,strong) NSString *boldFontName;
@property (strong,nonatomic) NSString *userId;
@property (nonatomic, retain) NSTimer *refreshTimer;
@property (strong,nonatomic) NSNumber *active_state;
@property (strong,nonatomic) NSNumber *flipped;
//holds all card data
@property (nonatomic, strong) NSMutableDictionary *cardData;
@property (nonatomic, strong) NSMutableArray *deck;
//card properties
@property (nonatomic, strong) Card *currentCard;
@property (nonatomic, strong) CardView *frontCardView;
@property (nonatomic, strong) CardView *backCardView;
@property (nonatomic, strong) NSString *senderName;
@property (nonatomic, strong) UIImage *selectedImage;
- (IBAction)upload:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)capture:(id)sender;
-(BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id )delegate;
@end
