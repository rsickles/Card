//
//  RegisterViewController.h
//  Memify
//
//  Created by Ryan Sickles on 7/4/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface RegisterViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    LoginViewController *loginViewController;
}
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property (strong,nonatomic) UIImage *image;
- (IBAction)signup:(id)sender;
- (IBAction)proPicUpload:(id)sender;
@end
