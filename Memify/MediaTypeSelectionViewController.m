//
//  MediaTypeSelectionViewController.m
//  Memify
//
//  Created by Ryan Sickles on 7/28/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "MediaTypeSelectionViewController.h"
#import "MediaTypeButton.h"

@interface MediaTypeSelectionViewController ()

@end

@implementation MediaTypeSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mediaTypeArray =
                @[
                [[MediaTypeButton alloc]initWithName:@"Search Internet (Google)" mediaImage:[UIImage imageNamed:@"SIGN-IN.png"]],
                [[MediaTypeButton alloc]initWithName:@"Image Link" mediaImage:[UIImage imageNamed:@"SIGN-IN.png"]],
                [[MediaTypeButton alloc]initWithName:@"Memes (Imgur)" mediaImage:[UIImage imageNamed:@"SIGN-IN.png"]],
                [[MediaTypeButton alloc]initWithName:@"Facebook" mediaImage:[UIImage imageNamed:@"SIGN-IN.png"]],
                [[MediaTypeButton alloc]initWithName:@"Camera Roll" mediaImage:[UIImage imageNamed:@"SIGN-IN.png"]],
                [[MediaTypeButton alloc]initWithName:@"Take Picture" mediaImage:[UIImage imageNamed:@"SIGN-IN.png"]]
                ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    int y = 20;
//    for(int i=0; i<[self.mediaTypeArray count]; i++)
//    {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        button.frame =  CGRectMake(20, y, 100, 40);
//        MediaTypeButton *mediaButton = [self.mediaTypeArray objectAtIndex:i];
//        [button setTitle:mediaButton.mediaType forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(goToForm) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:button];
//        y = y + 60;
//    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToForm:(id)sender {
    FormViewController *form = [[FormViewController alloc]initWithNibName:@"FormViewController" bundle:[NSBundle mainBundle]];
    UIButton *resultButton = (UIButton *)sender;
    NSLog(@"%@",resultButton.currentTitle);
    form.mediaType = resultButton.currentTitle;
    [self presentViewController:form animated:YES completion:nil];
}
@end
