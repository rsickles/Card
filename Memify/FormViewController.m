//
//  FormViewController.m
//  Memify
//
//  Created by Ryan Sickles on 7/12/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "FormViewController.h"

@interface FormViewController ()

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
    //end of styling buttons
    self.addFriend.delegate =self;
    [self.scrollView addSubview:self.searchMemes];
    [self.scrollView addSubview:self.memeImage];
    [self.scrollView addSubview:self.addFriend];
    [self.scrollView addSubview:self.friendName];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if(searchBar==self.addFriend)
    {
        NSLog(@"Adding Friends");
        [self.addFriend resignFirstResponder];
    }
    else if(searchBar==self.searchMemes)
    {
        NSLog(@"SearchingMemes");
        [self.searchMemes resignFirstResponder];
    }
    [self.view endEditing:TRUE]; //This will dismiss the keyboard
}

- (void) dismissKeyboard
{
    // add self
    [self.searchMemes resignFirstResponder];
    [self.addFriend resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if(searchBar==self.addFriend)
    {
        NSLog(@"Adding Friends");
        CGPoint scrollPoint = CGPointMake(0, 150);
        [self.scrollView setContentOffset:scrollPoint animated: YES];
    }
    else if(searchBar==self.searchMemes)
    {
        NSLog(@"SearchingMemes");
    }
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if(searchBar==self.addFriend)
    {
        NSLog(@"Adding Friends");
        [self.scrollView setContentOffset:CGPointZero animated: YES];
    }
    else if(searchBar==self.searchMemes)
    {
        NSLog(@"SearchingMemes");
    }
}


- (IBAction)sendMeme:(id)sender {
    NSLog(@"HFHDH");
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
