//
//  FormViewController.h
//  Memify
//
//  Created by Ryan Sickles on 7/12/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormViewController : UIViewController <UIViewControllerTransitioningDelegate>

@property CGFloat boundsx;
@property CGFloat boundsy;
@property (nonatomic,strong) UIColor *mainColor;
@property (nonatomic,strong) NSString *boldFontName;
@property (strong, nonatomic) IBOutlet UISearchBar *searchFriends;
@property (strong, nonatomic) IBOutlet UIImageView *memeImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;
- (IBAction)sendMeme:(id)sender;
- (IBAction)cancel:(id)sender;
@property (strong, nonatomic) IBOutlet UISearchBar *addFriend;
@property (strong, nonatomic) IBOutlet UILabel *friendName;
@end
