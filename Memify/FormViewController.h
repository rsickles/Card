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
#import <RTFacebookAlbum/RTFacebookAlbumViewController.h>
#import <RTFacebookAlbum/FacebookPhotoViewController.h>
@interface FormViewController : UIViewController <UIViewControllerTransitioningDelegate,UISearchBarDelegate,FBFriendPickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate,RTFacebookViewDelegate>

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
//- (IBAction)message:(id)sender;

@property (strong,nonatomic) NSString *userId;
@property (strong, nonatomic) NSDictionary *userData;
//properties being sent to card table
@property (strong,nonatomic) NSString *media_reference;
@property (strong, nonatomic) NSString *mediaType;
@property (strong,nonatomic) NSString *source_type;
@property (strong, nonatomic) NSString *message_text;
@property (strong, nonatomic) UITextView *textView;
@property (retain, nonatomic) IBOutlet UITextField *messageField;
@property (retain, nonatomic) IBOutlet UITextField *activeField;
@property (strong,nonatomic) UIScrollView *scrollView;
- (IBAction)touchUpInside:(id)sender;
- (IBAction)touchUpOutside:(id)sender;
@end
