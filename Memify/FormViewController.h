//
//  FormViewController.h
//  Memify
//
//  Created by Ryan Sickles on 7/12/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>


@interface FormViewController : UIViewController <UIViewControllerTransitioningDelegate,UISearchBarDelegate,FBFriendPickerDelegate>

@property CGFloat boundsx;
@property CGFloat boundsy;
@property (nonatomic,strong) UIColor *mainColor;
@property (nonatomic,strong) NSString *boldFontName;
@property (strong, nonatomic) IBOutlet UISearchBar *searchMemes;
@property (strong, nonatomic) IBOutlet UIImageView *memeImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;
- (IBAction)sendMeme:(id)sender;
- (IBAction)cancel:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)addFriend:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *addFriend;
@property (strong, nonatomic) IBOutlet UIButton *addFriendButton;
@property (strong, nonatomic) NSMutableArray *friendsList;
@end
