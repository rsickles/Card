//
//  FormViewController.m
//  Memify
//
//  Created by Ryan Sickles on 7/12/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "FormViewController.h"
#import <Parse/Parse.h>

@interface FormViewController () <FBFriendPickerDelegate>
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;
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
    [self.scrollView addSubview:self.searchMemes];
    [self.scrollView addSubview:self.memeImage];
    [self.scrollView addSubview:self.addFriend];
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
    NSLog(@"HFHDH");
}

- (IBAction)cancel:(id)sender {
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
    NSMutableString *text = [[NSMutableString alloc] init];

    // we pick up the users from the selection, and create a string that we use to update the text view
    // at the bottom of the display; note that self.selection is a property inherited from our base class
    for (id<FBGraphUser> user in self.friendPickerController.selection) {
        [self.friendsList addObject:user.name];
    }

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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}
@end
