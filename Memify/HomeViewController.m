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
    [self retrieveCards];
    [self createLogOutButton];
    [self createRefreshButton];
    [self constructNopeButton];
    [self constructLikedButton];
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
                [self createSendButton];
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
                [self createSendButton];
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


- (void)retrieveCards {
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            //get users facebook id
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            self.userId = userData[@"id"];
            [self getCardStack];
            }
    }];
}

-(void)getCardStack{
PFQuery *query = [PFQuery queryWithClassName:@"Junction"];
[query whereKey:@"RecipientId" equalTo:self.userId];
[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if(error || ([objects count] == 0) ){
        [self createSendButton];
    }
    else{
            self.cards = (NSMutableArray *)objects;
            //create array of users card stack
            for (int arrayIndex=0; arrayIndex<[self.cards count]; arrayIndex++) {
                NSString *cardId = [[self.cards objectAtIndex:arrayIndex ]objectForKey:@"CardId"];
                [self createCard:(cardId)];
                NSString *senderId = [[self.cards objectAtIndex:arrayIndex]objectForKey:@"SenderId"];
                [self getSenderName:senderId];
            }
    }
}];
}

-(void)getSenderName:(NSString *)senderId {
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    //get auth data hash authData.id
    [query whereKey:@"facebook_id" equalTo:senderId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if([objects count]>0)
        {
            self.senderName = [objects objectAtIndex:0];
        }
        else{
            self.senderName = @"N/A";
        }
    }];
}

-(void)createCard:(NSString *)cardId
{
    PFQuery *query = [PFQuery queryWithClassName:@"Cards"];
    [query whereKey:@"objectId" equalTo:cardId]; //change whereKey to senderID to see pics sent to self
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if([objects count] > 0)
        {
            
            NSURL *imageFileUrl = [[NSURL alloc]initWithString:[[objects objectAtIndex:0] objectForKey:@"media_reference"]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
            Card *card = [[Card alloc] initWithName:self.senderName image:[UIImage imageWithData:imageData] image:[UIImage imageWithData:imageData]];
            [self initializeCardStack:card];
        }
        else{
            [self createSendButton];
        }
    }];
}

-(void)initializeCardStack:(Card *)card
{
    [self.usersCards addObject:card];
    self.cards = self.usersCards;
    [self createSendButton];
    
    
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
    if([self.cards count] > 0)//has any meme cards in inbox
    {
        //display send button below cards
        memeButton.frame = CGRectMake(screenWidth/2-75, screenHeight-(screenHeight/4)+50, 150.0, 50.0);
    }
    else{
        //display send button in middle of screen
        memeButton.frame = CGRectMake(screenWidth/2-75, screenHeight/2-25, 150.0, 50.0);
    }
    [self.view addSubview:memeButton];
}


//transitioning stuff
- (IBAction) memeSend:(id)sender{
        NSLog(@"Send Meme!");
    self.animationController = [[DropAnimationController alloc] init];
    UIViewController *mediaSelection = [[MediaTypeSelectionViewController alloc]initWithNibName:@"MediaTypeSelectionViewController" bundle:[NSBundle mainBundle]];
    mediaSelection.transitioningDelegate  = self;
    [self presentViewController:mediaSelection animated:YES completion:nil];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
