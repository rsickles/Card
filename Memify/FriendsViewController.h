//
//  FriendsViewController.h
//  Memify
//
//  Created by Ryan Sickles on 7/10/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "HomeViewController.h"
@class HomeViewController;

@interface FriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    HomeViewController *home;
}

@property float xBound;
@property float yBound;
@property (nonatomic,strong) PFRelation *friendsRelation;
@property (nonatomic,strong) NSArray *friends;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
- (IBAction)back:(id)sender;

@end
