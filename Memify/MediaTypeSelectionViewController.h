//
//  MediaTypeSelectionViewController.h
//  Memify
//
//  Created by Ryan Sickles on 7/28/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormViewController.h"

@interface MediaTypeSelectionViewController : UIViewController
@property (strong, nonatomic) NSArray *mediaTypeArray;
@property (strong, nonatomic) IBOutlet UIButton *goToForm;
- (IBAction)goToForm:(id)sender;
@end
