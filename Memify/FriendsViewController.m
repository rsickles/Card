//
//  FriendsViewController.m
//  Memify
//
//  Created by Ryan Sickles on 7/10/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "FriendsViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface FriendsViewController ()

@end

@implementation FriendsViewController
@synthesize tableView;

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
    //get friends relation
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];

    
}

-(void)viewWillAppear:(BOOL)animated{
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error)
        {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        else{
            self.friends = objects;
            [tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.friends count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    cell.contentView.backgroundColor = [ UIColor colorWithRed:170.0/255.0 green:254.0/255.0 blue:140.0/255.0 alpha:1.0 ];
    cell.textLabel.backgroundColor = [ UIColor colorWithRed:170.0/255.0 green:254.0/255.0 blue:140.0/255.0 alpha:1.0 ];
    cell.textLabel.textColor = [ UIColor colorWithRed:0.0/255.0 green:201.0/255.0 blue:87.0/255.0 alpha:1.0 ];
    
    return cell;
}
- (IBAction)back:(id)sender {
    home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
    [self.view addSubview:home.view];
}
@end
