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
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

static const CGFloat ChoosePersonButtonHorizontalPadding = 80.f;
static const CGFloat ChoosePersonButtonVerticalPadding = 20.f;

@interface HomeViewController ()
@property (nonatomic, strong) NSMutableArray *cards;
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
    self.active_state = 0;
    self.flipped = 0;
    [self createSendButton];
    self.cards = [[NSMutableArray alloc] init];
    [self getCardsFromServer];
    //got cards
    [self createLogOutButton];
    [self createRefreshButton];
    
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0f];
    //make a request for data
    // Send request to Facebook
    

    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(refreshCards) userInfo:nil repeats:YES];

    
}



//refreshes the cards on the homepage
-(void)refreshCards{
    NSLog(@"REFRESHING CARDS");
    [self viewWillAppear:YES];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@.", self.currentCard.senderName);
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"You noped %@.", self.currentCard.senderName);
    } else {
        NSLog(@"You liked %@.", self.currentCard.senderName);
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
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }
}

#pragma mark - Internal Methods

- (void)setFrontCardView:(CardView *)frontCardView {
    // Keep track of the person currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
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
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };
    
    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
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
    UIImage *image = [UIImage imageNamed:@"nope"];
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
    UIImage *image = [UIImage imageNamed:@"liked"];
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



-(void)getCardsFromServer{
    FBRequest *request = [FBRequest requestForMe];
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            self.userId = userData[@"id"];
            PFQuery *query = [PFQuery queryWithClassName:@"Junction"];
            [query whereKey:@"RecipientId" equalTo:self.userId]; //change whereKey to senderID to see pics sent to self
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(error){
                    self.firstImage = nil;
                    [self createSendButton];
                }
                else{
                    //need to view first card then delete it after swiped so always grabbing first card to view
                    if([objects count]>0)
                    {
                        self.cards = (NSMutableArray *)objects;
                        NSLog(@"THIS IS THE OBJECTS ARRAY %@",self.cards);
                        [self initializeCards];
                    }
                    else{
                        
                        //there are no images
                    }
                }
            }];

        }
    }];
    
    
}


//swiped actions
-(void)cardSwiped
{
    PFObject *card = [PFObject objectWithClassName:@"Cards"];
    [card setObject:self.active_state forKey:@"active_state"];
    [card setObject:self.flipped forKey:@"flipped"];
    [card saveEventually];
}


- (void)initializeCards {
    // It would be trivial to download these from a web service
    // as needed, but for the purposes of this sample app we'll
    // simply store them in memory.
    NSMutableArray *usersCards = [[NSMutableArray alloc]init];
    //create array of users card stack
    NSLog(@"%@",self.cards);
    for (int arrayIndex=0; arrayIndex<[self.cards count]; arrayIndex++) {
        NSString *cardId = [[self.cards objectAtIndex:arrayIndex ]objectForKey:@"CardId"];
        NSLog(@"%@",cardId);
        PFQuery *query = [PFQuery queryWithClassName:@"Cards"];
        [query whereKey:@"objectId" equalTo:cardId]; //change whereKey to senderID to see pics sent to self
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSURL *imageFileUrl = [[NSURL alloc]initWithString:[[objects objectAtIndex:0] objectForKey:@"media_reference"]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
            Card *card = [[Card alloc] initWithName:@"SENDER NAME" image:[UIImage imageWithData:imageData] image:[UIImage imageWithData:imageData]];
            [usersCards addObject:card];
        }];
    }
    self.cards = usersCards;
    //set up cards
    // Display the first ChoosePersonView in front. Users can swipe to indicate
    // whether they like or dislike the person displayed.
    self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
    NSLog(@"THIS IS THE FIRST PIC %@",self.frontCardView);
    [self.view addSubview:self.frontCardView];
    
    // Display the second ChoosePersonView in back. This view controller uses
    // the MDCSwipeToChooseDelegate protocol methods to update the front and
    // back views after each user swipe.
    self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
    
    // Add buttons to programmatically swipe the view left or right.
    // See the `nopeFrontCardView` and `likeFrontCardView` methods.
    [self constructNopeButton];
    [self constructLikedButton];
    [self createSendButton];
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
        NSLog(@"MORE");
        memeButton.frame = CGRectMake(self.boundsx/2-75, self.boundsy-(self.boundsy/4)+50, 150.0, 50.0);
    }
    else{
        //display send button in middle of screen
        memeButton.frame = CGRectMake(self.boundsx/2-75, self.boundsy/2-25, 150.0, 50.0);
    }
    [self.view addSubview:memeButton];
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
