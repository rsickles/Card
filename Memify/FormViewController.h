//
//  FormViewController.h
//  Memify
//
//  Created by Ryan Sickles on 7/12/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <AFNetworking.h>
#import "HomeViewController.h"
#import <Parse/Parse.h>

@interface FormViewController : UIViewController <UIViewControllerTransitioningDelegate,UISearchBarDelegate,FBFriendPickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property CGFloat boundsx;
@property CGFloat boundsy;
@property (nonatomic,strong) UIColor *mainColor;
@property (nonatomic,strong) NSString *boldFontName;
@property (strong, nonatomic) IBOutlet UISearchBar *searchMemes;
@property (strong, nonatomic) IBOutlet UIImageView *memeImageView;
- (IBAction)imageSelect:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;
- (IBAction)sendMeme:(id)sender;
- (IBAction)cancel:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *selectImage;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)addFriend:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *addFriend;
@property (strong, nonatomic) IBOutlet UIButton *addFriendButton;
@property (strong, nonatomic) NSMutableArray *friendsList;
@property (strong, nonatomic) UIImage *memeImage;
-(void)saveImageSelectedtoUser:(UIImage*)image friends:(NSMutableArray *)friends;
- (IBAction)message:(id)sender;
@property (strong,nonatomic) NSString *userId;
@property (strong,nonatomic) NSString *media_reference;
@property (strong,nonatomic) NSString *source_type;
@property (strong, nonatomic) NSString *message_text;
@property (strong, nonatomic) NSDictionary *userData;
//media type being passed from media type picker
@property (strong, nonatomic) NSString *mediaType;
@end
