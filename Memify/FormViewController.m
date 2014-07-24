//
//  FormViewController.m
//  Memify
//  Created by Ryan Sickles on 7/12/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//
#import "FormViewController.h"

@interface FormViewController () <FBFriendPickerDelegate, UINavigationControllerDelegate>
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (retain,nonatomic) UINavigationController *navigationController;
@end

@implementation FormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.boundsx = [UIScreen mainScreen].bounds.size.width;
        self.boundsy = [UIScreen mainScreen].bounds.size.height;
        self.mainColor = [UIColor colorWithRed:222.0/255 green:59.0/255 blue:47.0/255 alpha:1.0f];
        self.boldFontName = @"Avenir-Black";

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.taskBar addTarget:self action:@selector(taskBarAction:) forControlEvents:UIControlEventValueChanged];
    FBRequest *request = [FBRequest requestForMe];
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            self.userId = userData[@"id"];
        }
    }];
    self.searchMemes.delegate = self;
    //set custom buttons
    self.sendButton.backgroundColor = self.mainColor;
    self.sendButton.layer.cornerRadius = 3.0f;
    self.sendButton.titleLabel.font = [UIFont fontWithName:self.boldFontName size:20.0f];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    //cancel button
    self.cancelButton.backgroundColor = self.mainColor;
    self.cancelButton.layer.cornerRadius = 3.0f;
    self.cancelButton.titleLabel.font = [UIFont fontWithName:self.boldFontName size:20.0f];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    //add recipients button
    self.addFriendButton.backgroundColor = self.mainColor;
    self.addFriendButton.layer.cornerRadius = 3.0f;
    self.addFriendButton.titleLabel.font = [UIFont fontWithName:self.boldFontName size:20.0f];
    [self.addFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addFriendButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    //end of styling buttons
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidUnload {
    self.friendPickerController = nil;

    [super viewDidUnload];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchMemes resignFirstResponder];
    self.memeImageView.image = nil;
    [self.view endEditing:TRUE]; //This will dismiss the keyboard
    //start spinning wheel and searching for meme
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityView.center=self.view.center;
    activityView.color = [UIColor redColor];
    [activityView startAnimating];
    //get image query
    NSMutableString *imageQuery = [[[searchBar.text mutableCopy] stringByReplacingOccurrencesOfString:@" " withString:@""]mutableCopy];
    NSMutableString *query = [@"https://api.imgur.com/3/gallery/search/?q=" mutableCopy];
    //construct query string
    [query appendString:imageQuery];
    //end of query string
    [self.view addSubview:activityView];
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    [operationManager.requestSerializer setValue:@"Client-ID 5df88b59be0ed8d" forHTTPHeaderField:@"Authorization"];
    NSLog(@"This is the text you're searching for %@",query);
    [operationManager GET:query parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //parse returned array object
        NSDictionary *images = responseObject;
        NSArray *values = [images allValues];
        NSInteger number_of_images = [[values objectAtIndex:0] count ];
        if(number_of_images>0)
        {
            //get random image
            int r = arc4random() % number_of_images;
            //
            id val = [values objectAtIndex:0];
            id nextval = [val objectAtIndex:r];
            NSString *link = [nextval objectForKey:@"link"];
            self.media_reference = link;
            //set url with string
            NSURL *url = [NSURL URLWithString:link];
            self.memeImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
            self.memeImageView.image = self.memeImage;
            [activityView stopAnimating];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Such Picture Exists On IMGUR :(" message:@"Try Again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [activityView stopAnimating];
        self.memeImageView.image = nil;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Retrieving Media Failed" message:@"Try Again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }];

}
- (void) dismissKeyboard
{
    // add self
    [self.searchMemes resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
        NSLog(@"SearchingMemes");
    //clear view
    self.memeImageView.image = nil;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
        NSLog(@"SearchingMemes");
}


- (IBAction)sendMeme:(id)sender {
    //alert user they haven't selected an image to send
    if(self.memeImage == nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"No Picture Being Sent" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        
       [alertView show];
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    else if (self.friendsList.count<=0){
        //alert user they have selected no friends
        //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"Remember to choose some friends!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        //
        //[alertView show];
        
        //[alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    else
    {
        [self saveImageSelectedtoUser:self.memeImage friends:self.friendsList];
        UIViewController *home = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
        [self presentViewController:home animated:YES completion:nil];
        
    }
}

- (IBAction)cancel:(id)sender {
    NSLog(@"CANCELED");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addFriend:(id)sender {
    // FBSample logic
    // if the session is open, then load the data for our view controller
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_friends"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                  message:error.localizedDescription
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                          } else if (session.isOpen) {
                                              [self addFriend:sender];
                                          }
                                      }];
        return;
    }


    if (self.friendPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Pick Friends";
        self.friendPickerController.delegate = self;
    }

    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    //wrapped in a navigation controller so modal view is not blocked by status bar
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.friendPickerController];
    [self presentViewController:nav animated:YES completion:nil];

}
- (void)facebookViewControllerDoneWasPressed:(id)sender {
    self.friendsList = [[NSMutableArray alloc] init];
    // we pick up the users from the selection, and create a string that we use to update the text view
    // at the bottom of the display; note that self.selection is a property inherited from our base class
    for (PFUser<FBGraphUser> *user in self.friendPickerController.selection) {
        NSLog(@"Users names added is %@",user.objectID);
        [self.friendsList addObject:user.objectID];
    }
    NSLog(@"Users names full list %@",self.friendsList);
    //[self fillTextBoxAndDismiss:text.length > 0 ? text : @"<None>"]; send to Parse as users to send to
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)facebookViewControllerCancelWasPressed:(id)sender {
    //requests to invite users to use application
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                      message:@"Invite Friends to Use Card"
                                                        title:@"Invite Friends to Use Card"
                                                   parameters:nil
                                                      handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                          if (error) {
                                                              // Case A: Error launching the dialog or sending request.
                                                              NSLog(@"Error sending request.");
                                                          } else {
                                                              if (result == FBWebDialogResultDialogNotCompleted) {
                                                                  // Case B: User clicked the "x" icon
                                                                  NSLog(@"User canceled request.");
                                                                  [self dismissViewControllerAnimated:YES completion:NULL];
                                                              } else {
                                                                  NSLog(@"Request Sent.");
                                                              }
                                                          }}
         ];

}


-(void)saveImageSelectedtoUser:(UIImage*)image friends:(NSMutableArray *)friends
{
    
    //get your own facebook id
    
    NSData *fileData;
    NSString *fileName;
    NSString *mediaType;
    if(self.memeImage != nil)
    {
        UIImage *newImage = [self resizeImage:image toWidth:320.0f andHeight:480.0f];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        mediaType = @"image";
    }
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Try Sending Picture Again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alertView show];
        }
        else{
            //Picture is sent so remove all recipients!
            PFObject *card = [PFObject objectWithClassName:@"Cards"];
            [card setObject:self.media_reference forKey:@"media_reference"];
            [card setObject:mediaType forKey:@"media_type"];
            [card setObject:self.source_type forKey:@"source_type"];
            [card setObject:self.message_text forKey:@"message"];
            //[card setObject:self.active_state forKey:@"active_state"]; add to homeview based on swipe
            ////[card setObject:self.flipped forKey:@"flipped"]; add to homeview based on swipe
            //[card setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            
            [card saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(error){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Try Sending Picture Again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    
                    [alertView show];
                }
                else{
                    self.memeImage = nil;
                    //save to parse is successful!
                    //go to back to homepage
                    
                }
            }];
        }
    }];
}

//resize image to needed size
-(UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height{
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [self.memeImage drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

- (IBAction)taskBarAction:(id)sender {
    
    UISegmentedControl *segmentedControl = sender;
    NSString *controlText = [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]];
    if([controlText isEqualToString:@"Internet"])
    {
        [self.view addSubview:self.searchMemes];
        self.source_type = @"Internet";
    }
    if([controlText isEqualToString:@"Photo Library"])
    {
        //Creates imagepicker modally
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        //adds it to the form screen
        imagePickerController.delegate = self;
        
        [self.searchMemes removeFromSuperview];
        self.source_type = @"Photo_Library";
        //Creates imagepicker modally
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        //adds it to the form screen
        
        
        if([self.navigationController isKindOfClass:[UIImagePickerController class]]){
            UINavigationBar *bar = self.navigationController.navigationBar;
            UINavigationItem *top = bar.topItem;
            
            UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(imagePickerControllerDidCancel:)];
            [top setLeftBarButtonItem:cancel];
            
        }
        imagePickerController.delegate = self;
        /*UINavigationBar *bar = navigationController.navigationBar;
        UINavigationItem *top = bar.topItem;
        
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(imagePickerControllerDidCancel:)];
        [top setLeftBarButtonItem:cancel];*/

        [self presentViewController:imagePickerController animated:NO completion:nil];
    }
    if([controlText isEqualToString:@"Facebook"])
    {
        [self.searchMemes removeFromSuperview];
        self.source_type = @"Facebook";
    }
    
    
}

//goes back to FormViewController when cancel is hit
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Finds the image and sets the image and imageView the returns to the FormViewController
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.memeImageView.image = image;
    self.memeImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}
- (IBAction)message:(UITextField *)sender {
    self.message_text = sender.text;
}
@end


//UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:nil action:@selector(imagePickerControllerDidCancel:)];


//UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.navigationController];
//[self presentViewController:nav animated:YES completion:nil];

//[bar leftBarButtonItem:cancelNavButton animated:YES];


/*if([self.navigationController isKindOfClass:[UIImagePickerController class]]){
 UINavigationBar *bar = self.navigationController.navigationBar;
 UINavigationItem *top = bar.topItem;
 
 UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(imagePickerControllerDidCancel:)];
 [top setLeftBarButtonItem:cancel];
 
 }
 
 UINavigationBar *bar = navigationController.navigationBar;
 UINavigationItem *top = bar.topItem;
 
 UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(imagePickerControllerDidCancel:)];
 [top setLeftBarButtonItem:cancel];*/
