//
//  HomeViewController.m
//  Memify
//
//  Created by Ryan Sickles on 7/4/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "HomeViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ADVAnimationController.h"
#import <Parse/Parse.h>


@interface HomeViewController ()

@property (nonatomic, strong) id<ADVAnimationController> animationController;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.boundsx = [UIScreen mainScreen].bounds.size.width;
        self.boundsy = [UIScreen mainScreen].bounds.size.height;
        self.mainColor = [UIColor colorWithRed:222.0/255 green:59.0/255 blue:47.0/255 alpha:1.0f];
        self.boldFontName = @"Avenir-Black";
        self.firstImage = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    FBRequest *request = [FBRequest requestForMe];
    [self createLogOutButton];
    [self createRefreshButton];
    
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0f];
    //make a request for data
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
//            NSString *facebookID = userData[@"id"];
            //add name if neccessary in cool font above image
            NSString *name = userData[@"name"];
            float originx = ([UIScreen mainScreen].bounds.size.width/2) - 50;
            float originy = ([UIScreen mainScreen].bounds.size.height/2) - 100;
            UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(originx, originy, 100.0 , 50.0)];
            userName.text = name;
//            [self.view addSubview:userName];
            
            // Now add the data to the UI elements
            // ...
            // Download the user's facebook profile picture
            _imageData = [[NSMutableData alloc] init]; // the data will be loaded in here
            
            // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
//            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
//            
//            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
//                                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                                  timeoutInterval:2.0f];
            // Run network request asynchronously
//            [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        }
    }];
    

    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(refreshCards) userInfo:nil repeats:YES];

    
}


//refreshes the cards on the homepage
-(void)refreshCards{
    NSLog(@"REFRESHING CARDS");
    [self viewWillAppear:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    FBRequest *request = [FBRequest requestForMe];
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            NSLog(@"%@",userData);
            self.userId = userData[@"id"];
            PFQuery *query = [PFQuery queryWithClassName:@"Cards"];
            [query whereKey:@"recipientIds" equalTo:self.userId]; //change whereKey to senderID to see pics sent to self
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(error){
                    self.firstImage = nil;
                    [self createSendButton];
                }
                else{
                    //need to view first card then delete it after swiped so always grabbing first card to view
                    if([objects count]>0)
                    {
                        self.firstImage = [objects objectAtIndex:0];
                        PFFile *image = [self.firstImage objectForKey:@"file"];
                        NSURL *imageFileUrl = [[NSURL alloc]initWithString:image.url];
                        NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
                        self.cardImage.image = [UIImage imageWithData:imageData];
                        //        self.messages = objects;
                        //        [self.tableView reloadData];
                    }
                    else{
                        
                        //there are no images
                    }
                    [self createSendButton];
                }
            }];

        }
    }];
    
    
}



-(void)createLogOutButton
{
    //add log out button
    UIButton *logout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [logout addTarget:self action:@selector(logoutButtonTouchHandler:)forControlEvents:UIControlEventTouchUpInside];
    [logout setTitle:@"Logout" forState:UIControlStateNormal];
    logout.backgroundColor = self.mainColor;
    logout.layer.cornerRadius = 3.0f;
    logout.titleLabel.font = [UIFont fontWithName:self.boldFontName size:20.0f];
    [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    logout.frame = CGRectMake(10, 75, 75.0, 35.0);
    [self.view addSubview:logout];
}


-(void)createRefreshButton{
    
    //create the refresh button which refreshes the cards when pressed
    UIButton *refresh = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [refresh addTarget:self action:@selector(refreshCards)forControlEvents:UIControlEventTouchUpInside];
    [refresh setTitle:@"Shuffle" forState:UIControlStateNormal];
    refresh.backgroundColor = self.mainColor;
    refresh.layer.cornerRadius = 3.0f;
    refresh.titleLabel.font = [UIFont fontWithName:self.boldFontName size:20.0f];
    [refresh setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [refresh setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    refresh.frame = CGRectMake(225, 75, 75.0, 35.0);
    [self.view addSubview:refresh];

}

-(void)createSendButton
{
    //create initial button
    UIButton *memeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [memeButton addTarget:self action:@selector(memeSend:) forControlEvents:UIControlEventTouchUpInside];
    [memeButton setTitle:@"Send Card" forState:UIControlStateNormal];
    memeButton.backgroundColor = self.mainColor;
    memeButton.layer.cornerRadius = 3.0f;
    memeButton.titleLabel.font = [UIFont fontWithName:self.boldFontName size:20.0f];
    [memeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [memeButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    NSLog(@"%@",self.firstImage);
    if(self.firstImage != nil)//has any meme cards in inbox
    {
        //display send button below cards
        memeButton.frame = CGRectMake(self.boundsx/2-75, self.boundsy-(self.boundsy/4)+50, 150.0, 50.0);
    }
    else{
        //display send button in middle of screen
        memeButton.frame = CGRectMake(self.boundsx/2-75, self.boundsy/2-25, 150.0, 50.0);
    }
    [self.view addSubview:memeButton];
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
//    [self.view addSubview:profileButton];
}

- (IBAction)friendList:(id)sender {
    NSLog(@"To Friends List!");
}


//transitioning stuff
- (IBAction) memeSend:(id)sender{
        NSLog(@"Send Meme!");
    self.animationController = [[DropAnimationController alloc] init];
    UIViewController *form = [[FormViewController alloc]initWithNibName:@"FormViewController" bundle:[NSBundle mainBundle]];
    form.transitioningDelegate  = self;
    [self presentViewController:form animated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    self.animationController.isPresenting = YES;
    
    return self.animationController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.animationController.isPresenting = NO;
    
    return self.animationController;
}
//end of transitioning stuff

- (void)logoutButtonTouchHandler:(id)sender  {
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession openActiveSessionWithReadPermissions:nil
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
                                              //run your user info request here
                                              [PFUser logOut]; // Log out
                                              // Return to login page
                                              NSLog((@"Logout"));
                                              login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
                                              [self.view addSubview:login.view];
                                          }
                                      }];
}
    [PFUser logOut]; // Log out
    // Return to login page
    NSLog((@"Logout"));
    login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    [self.view addSubview:login.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
