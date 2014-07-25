//
//  CardView.h
//  Memify
//
//  Created by Ryan Sickles on 7/23/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

@class Card;

@interface CardView : MDCSwipeToChooseView

@property (nonatomic, strong, readonly) Card *card;
- (instancetype)initWithFrame:(CGRect)frame card:(Card *)card options:(MDCSwipeToChooseViewOptions *)options;
@end
