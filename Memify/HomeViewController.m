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
#import "Card.h"
#import "GlobalVariables.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>

static const CGFloat ChoosePersonButtonHorizontalPadding = 80.f;
static const CGFloat ChoosePersonButtonVerticalPadding = 20.f;

@interface HomeViewController ()
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) NSMutableArray *usersCards;
@property (nonatomic, strong) id<ADVAnimationController> animationController;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.usersCards = [[NSMutableArray alloc]init];
        self.mainColor = [UIColor colorWithRed:222.0/255 green:59.0/255 blue:47.0/255 alpha:1.0f];
        self.boldFontName = @"Avenir-Black";
        self.active_state = 0;
        self.flipped = 0;
        self.cards = [[NSMutableArray alloc] init];
        self.view.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0f];
        self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(refreshCards) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self constructNopeButton];
    [self constructLikedButton];
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            //get users facebook id
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            self.userId = userData[@"id"];
            [self getAllCardsSentToUser];
            self.deck = [[NSMutableArray alloc]init];
        }
    }];

}

-(void)refreshCards{
    NSLog(@"REFRESHING CARDS");
    [self viewWillAppear:YES];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@.", self.currentCard.senderName);
}

- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"You noped %@.", self.currentCard.senderName);
        
        PFQuery *query = [PFQuery queryWithClassName:@"Junction"];
        [query whereKey:@"RecipientId" equalTo:self.userId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(error || ([objects count] == 0) ){
            }
            else{
                self.cards = (NSMutableArray *)objects;
                //create array of users card stack
                PFObject *usedCard = [self.cards objectAtIndex:0];
                [usedCard deleteInBackground];
                NSLog(@"Card Deleted");
            }
        }];
        
        
        
        NSLog(@"Saved Card");

        
        
    } else {
        NSLog(@"You liked %@.", self.currentCard.senderName);
        //saves image to saved photos album
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:_imageData], nil, nil, nil);
        
        //deletes card from junction table
    
        PFQuery *query = [PFQuery queryWithClassName:@"Junction"];
        [query whereKey:@"RecipientId" equalTo:self.userId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(error || ([objects count] == 0) ){
            }
            else{
                self.cards = (NSMutableArray *)objects;
                //create array of users card stack
                PFObject *usedCard = [self.cards objectAtIndex:0];
                [usedCard deleteInBackground];
                NSLog(@"Card Deleted");
            }
        }];
        
        
        
        NSLog(@"Saved Card");
        
    }
    
    // MDCSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // MDCSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
    self.frontCardView = self.backCardView;
    if ((self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]])) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{ self.backCardView.alpha = 1.f; } completion:nil];
    }
}

#pragma mark - Internal Methods

- (void)setFrontCardView:(CardView *)frontCardView {
    // Keep track of the person currently being chosen.
    _frontCardView = frontCardView;
    self.currentCard = frontCardView.card;
}

- (CardView *)popPersonViewWithFrame:(CGRect)frame {
    if ([self.cards count] == 0) {
        return nil;
    }
    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,frame.origin.y - (state.thresholdRatio * 10.f),CGRectGetWidth(frame),CGRectGetHeight(frame));
    };
    // Create a personView with the top person in the people array, then pop that person off the stack
    CardView *cardView = [[CardView alloc] initWithFrame:frame card:[self.cards objectAtIndex:0] options:options];
    [self.cards removeObjectAtIndex:0];
    return cardView;
}

#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 60.f;
    CGFloat bottomPadding = 200.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}

// Create and add the "nope" button.
- (void)constructNopeButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"Delete"];
    button.frame = CGRectMake(ChoosePersonButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:247.f/255.f
                                         green:91.f/255.f
                                          blue:37.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(nopeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

// Create and add the "like" button.
- (void)constructLikedButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"Save"];
    button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChoosePersonButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:29.f/255.f
                                         green:245.f/255.f
                                          blue:106.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(likeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark Control Events

// Programmatically "nopes" the front card view.
- (void)nopeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}

// Programmatically "likes" the front card view.
- (void)likeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}

//swiped actions
-(void)cardSwiped
{
    PFObject *card = [PFObject objectWithClassName:@"Cards"];
    [card setObject:self.active_state forKey:@"active_state"];
    [card setObject:self.flipped forKey:@"flipped"];
    [card saveEventually];
}


-(void)getAllCardsSentToUser{
PFQuery *query = [PFQuery queryWithClassName:@"Junction"];
[query whereKey:@"RecipientId" equalTo:self.userId];
[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if(error || ([objects count] == 0) ){
    }
    else{
            //gets all cards for user to download
            self.cards = (NSMutableArray *)objects;
            //create array of users card stack
            for (int arrayIndex=0; arrayIndex<[self.cards count]; arrayIndex++) {
                //creates new hash set for card data and adds time sent
                self.cardData = [[NSMutableDictionary alloc] init];
                //add time sent to Card Data
                [self.cardData setObject:[[self.cards objectAtIndex:arrayIndex]createdAt] forKey:@"timeSent"];
                //adds cardID to Card Data
                [self.cardData setObject:[[self.cards objectAtIndex:arrayIndex]objectForKey:@"CardId"] forKey:@"CardId"];
                //adds senderID to Card Data
                [self.cardData setObject:[[self.cards objectAtIndex:arrayIndex]objectForKey:@"SenderId"] forKey:@"SenderId"];
                //adds to deck
                [self.deck addObject:self.cardData];
            }
        //now gets info about card and user that sent the card
        [self getSenderInfo:(self.deck)];
    }
}];
    
}

-(void)getSenderInfo:(NSArray *)deck{
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    //get auth data hash authData.id
    for (int arrayIndex=0; arrayIndex<[self.cards count]; arrayIndex++)
    {
        NSString *senderId = [[deck objectAtIndex:arrayIndex] objectForKey:@"SenderId"];
        [query whereKey:@"facebook_id" equalTo:senderId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSMutableString *full_name = [[objects objectAtIndex:0]objectForKey:@"first_name"];
            NSMutableString *last_name = [[objects objectAtIndex:0]objectForKey:@"last_name"];
            [full_name appendString:last_name];
            //add senders name to cardData
            [[deck objectAtIndex:arrayIndex]setObject:full_name forKey:@"senderName"];
            //add senders propic to arrayIndex
            //construct query string
            NSMutableString *imageQuery = [[senderId mutableCopy]mutableCopy];
            NSMutableString *query = [@"https://graph.facebook.com/" mutableCopy];
            [query appendString:imageQuery];
            [query appendString:@"/picture"];
            //get pro pic
            NSURL *url = [NSURL URLWithString:query];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *proPic = [[UIImage alloc] initWithData:data];
            [[deck objectAtIndex:arrayIndex]setObject:proPic forKey:@"senderProPic"];
        }];
    }
    [self getCardInfo:(deck)];
}

-(void)getCardInfo:(NSArray *)deck
{
    PFQuery *query = [PFQuery queryWithClassName:@"Cards"];
    for (int arrayIndex=0; arrayIndex<[self.cards count]; arrayIndex++)
    {
        NSString *cardId = [[deck objectAtIndex:arrayIndex] objectForKey:@"CardId"];
        [query whereKey:@"objectId" equalTo:cardId]; //change whereKey to senderID to see pics sent to self
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if([objects count] > 0)
            {
                NSString *media_type = [[objects objectAtIndex:0]objectForKey:@"media_type"];
                //set card media type (photo/video)
                [[deck objectAtIndex:arrayIndex]setObject:media_type forKey:@"mediaType"];
                NSString *message = [[objects objectAtIndex:0]objectForKey:@"message"];
                //set card message
                [[deck objectAtIndex:arrayIndex]setObject:message forKey:@"message"];
                if([media_type isEqualToString:@"Image"])
                {
                    //its an image file
                    PFQuery *query = [PFQuery queryWithClassName:@"personal_images"];
                    [query whereKey:@"CardId" equalTo:cardId];
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        PFFile *image = [[objects objectAtIndex:0]objectForKey:@"imageFile"];
                        //set card message
                        [[deck objectAtIndex:arrayIndex]setObject:image forKey:@"imageData"];
                    }];
                }
                else{
                    //its a video file
                }
            }
        }];

    }
    [self createCardStack:deck];
}

-(void)createCardStack:(NSArray *)deck
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    for (int arrayIndex=0; arrayIndex<[self.cards count]; arrayIndex++)
    {
        //formats date into string
        NSString *stringFromDate = [formatter stringFromDate:[[deck objectAtIndex:arrayIndex] objectForKey:@"timeSent"]];
        
        NSString *timeSent = stringFromDate;
        NSString *senderName = [[deck objectAtIndex:arrayIndex] objectForKey:@"senderName"];
        UIImage *senderProPic = [[deck objectAtIndex:arrayIndex] objectForKey:@"senderProPic"];
        NSString *message = [[deck objectAtIndex:arrayIndex] objectForKey:@"message"];
        NSString *mediaData = [[deck objectAtIndex:arrayIndex] objectForKey:@"imageData"];
        NSString *mediaType = [[deck objectAtIndex:arrayIndex] objectForKey:@"mediaType"];
        Card *card = [[Card alloc] initWithName:senderName image:senderProPic image:mediaData message:message timeSent:timeSent mediaType:mediaType];
        NSLog(@"%@",card);
        //add cards to the stack
        [self.usersCards addObject:card];
    }
    self.cards = self.usersCards;
    
    self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
    [self.view addSubview:self.frontCardView];
    self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
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


//-(void)createRefreshButton{
//    
//    //create the refresh button which refreshes the cards when pressed
//    UIButton *refresh = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [refresh addTarget:self action:@selector(refreshCards)forControlEvents:UIControlEventTouchUpInside];
//    [refresh setTitle:@"Shuffle" forState:UIControlStateNormal];
//    refresh.backgroundColor = self.mainColor;
//    refresh.layer.cornerRadius = 3.0f;
//    refresh.titleLabel.font = [UIFont fontWithName:self.boldFontName size:20.0f];
//    [refresh setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [refresh setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
//    refresh.frame = CGRectMake(225, 75, 75.0, 35.0);
//    [self.view addSubview:refresh];
//
//}





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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)upload:(id)sender {
    [self startMediaBrowserFromViewController:self usingDelegate:self];
}

-(BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id )delegate {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        return NO;
    }
    
    
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    
    imagePickerController.mediaTypes = @[(NSString *) kUTTypeImage, (NSString *) kUTTypeMovie];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerController.allowsEditing = NO;
    imagePickerController.delegate = delegate;
    UINavigationBar *bar = imagePickerController.navigationBar;
    UINavigationItem *top = bar.topItem;
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(imagePickerControllerDidCancel:)];
    [top setLeftBarButtonItem:cancel];
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    return YES;
}


-(void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Finds the image and sets the image and imageView the returns to the FormViewController
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    UIImage *image = nil;
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        // Media is an image
        image = [info valueForKey:UIImagePickerControllerOriginalImage];
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
     //media is a movie
        NSURL *movieURL = (NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        MPMoviePlayerController *movieplayer =[[MPMoviePlayerController alloc] initWithContentURL:movieURL];
        [[movieplayer view] setFrame: [self.view bounds]];
        [self.view addSubview: [movieplayer view]];
    }
    self.selectedImage = image;
    [self dismissViewControllerAnimated:YES completion:^{
        FormViewController *form = [[FormViewController alloc]initWithNibName:@"FormViewController" bundle:[NSBundle mainBundle]];
        form.imageSelected = self.selectedImage;
        [self presentViewController:form animated:YES completion:nil];
    }];

}



// When the movie is done, release the controller.
-(void)myMovieFinishedCallback:(NSNotification*)aNotification {
    [self dismissMoviePlayerViewControllerAnimated];
    MPMoviePlayerController* theMovie = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
}


- (IBAction)logout:(id)sender {
    login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
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
                                              [self presentViewController:login animated:YES completion:nil];
                                          }
                                      }];
    }
    [PFUser logOut]; // Log out
    // Return to login page
    NSLog((@"Logout"));
    [self presentViewController:login animated:YES completion:nil];

}

- (IBAction)capture:(id)sender {
    //open camera/video taker
    UIImagePickerController *camera = [[UIImagePickerController alloc]init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        camera.sourceType = UIImagePickerControllerSourceTypeCamera;
        camera.delegate = self;
        [self presentViewController:camera animated:YES completion:nil];
    }
    else
    {
        NSLog(@"NO CAMERA FOUND");
    }
}
@end
