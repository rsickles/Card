//
//  RegisterViewController.m
//  Memify
//
//  Created by Ryan Sickles on 7/4/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "RegisterViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize loginViewController;

//instantiates view controller
-(LoginViewController *)loginViewController{
    if(!loginViewController){
        loginViewController = [[LoginViewController alloc]initWithNibName:nil bundle:nil];
        loginViewController.title = @"Login";
    }
    return loginViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signup:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([username length] == 0 || [password length] == 0 || [email length] == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Some fields are incomplete" delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil];
        
        [alert show];
    }
    else
    {
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.email = email;
        newUser.password = password;
        
        [newUser signUpInBackgroundWithBlock: ^(BOOL succeeded, NSError *error){
            if(error){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
//                //resize pro pic image
//                UIGraphicsBeginImageContext(CGSizeMake(640, 960));
//                [self.image drawInRect: CGRectMake(0, 0, 640, 960)];
//                NSData *imageData = UIImageJPEGRepresentation(self.image, 0.05f);
//                PFFile *imageFile = [PFFile fileWithName:@"pro-pic.jpg" data:imageData];
//                //have to upload image
//                PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
//                [userPhoto setObject:imageFile forKey:@"imageFile"];
//                [userPhoto setObject:newUser forKey:@"user"];
//                [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                    if (error) {
//                        // Log details of the failure
//                        NSLog(@"Error: %@ %@", error, [error userInfo]);
//                    }
//                    else{
//                        
//                    }
//                }];
                //end of uploading pro pic image
                [self.navigationController pushViewController:self.loginViewController animated:YES];
            }
        }];
        //sequential code being run
        
    }
}


//invovled with picking image
-(IBAction)proPicUpload:(id)sender{
//    UIImagePickerController *controller = [segue destinationViewController];
//    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    if([mediaType isEqualToString:(NSString *)kUTTypeImage])
//    {
//        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        
//    }
//    else{
//        //alert that it is not an image
//    }
//}

@end
