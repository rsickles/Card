//
//  HomeViewController.m
//  Memify
//
//  Created by Ryan Sickles on 7/4/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "HomeViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

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
    //add log out button
    UIButton *logout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [logout setTitle:@"Logout" forState:UIControlStateNormal];
    [logout setFrame:CGRectMake(0,25,100,100)];
    [logout addTarget:self action:@selector(logoutButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logout];
    // Do any additional setup after loading the view from its nib.
    //make a request for data
    FBRequest *request = [FBRequest requestForMe];
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            NSString *facebookID = userData[@"id"];
            //add name if neccessary in cool font above image
            NSString *name = userData[@"name"];
            float originx = ([UIScreen mainScreen].bounds.size.width/2) - 50;
            float originy = ([UIScreen mainScreen].bounds.size.height/2) - 100;
            UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(originx, originy, 100.0 , 50.0)];
            userName.text = name;
            [self.view addSubview:userName];
            
            // Now add the data to the UI elements
            // ...
            // Download the user's facebook profile picture
            _imageData = [[NSMutableData alloc] init]; // the data will be loaded in here
            
            // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                  timeoutInterval:2.0f];
            // Run network request asynchronously
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        }
    }];
}

// Called every time a chunk of the data is received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_imageData appendData:data]; // Build the image
}

// Called when the entire profile image is finished downloading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Set the image in the header imageView should be in top middle
    float originx = ([UIScreen mainScreen].bounds.size.width/2) - 50;
    float originy = ([UIScreen mainScreen].bounds.size.height/2) - 50;
    //get image
    UIImage *proPicImage = [UIImage imageWithData:_imageData];
    //make button with image
    UIButton *profileButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [profileButton setBackgroundImage:proPicImage forState:UIControlStateNormal];
    profileButton.frame = CGRectMake(originx,originy,100,100);
    [profileButton addTarget:self action:@selector(friendList:) forControlEvents:UIControlEventTouchUpInside];
    //make image rounded
    profileButton.layer.cornerRadius = profileButton.frame.size.height /2;
    profileButton.layer.masksToBounds = YES;
    profileButton.layer.borderWidth = 0;
    [self.view addSubview:profileButton];
    //make button to send Meme
    UIButton *memeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [memeButton addTarget:self action:@selector(memeSend:) forControlEvents:UIControlEventTouchUpInside];
    [memeButton setTitle:@"Send Meme" forState:UIControlStateNormal];
    memeButton.frame = CGRectMake(originx, originy+100.0, 100.0, 100.0);
    [self.view addSubview:memeButton];
}

- (IBAction)friendList:(id)sender {
    NSLog(@"To Friends List!");
    friendsPage = [[FriendsViewController alloc]initWithNibName:@"FriendsViewController" bundle:[NSBundle mainBundle]];
    [self.view addSubview:friendsPage.view];
}

- (IBAction) memeSend:(id)sender{
    NSLog(@"Send Meme!");
}

- (void)logoutButtonTouchHandler:(id)sender  {
    [PFUser logOut]; // Log out
    // Return to login page
    NSLog((@"LOGOUT"));
    login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    [self.view addSubview:login.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
