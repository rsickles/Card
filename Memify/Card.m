//
//  Card.m
//  Memify
//
//  Created by Ryan Sickles on 7/23/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "Card.h"

@implementation Card

#pragma mark - Object Lifecycle

- (instancetype)initWithName:(NSString *)senderName image:(UIImage *)image image:(UIImage *)senderProPic{
    self = [super init];
    if (self) {
        _senderName = senderName;
        _image = image;
        _senderProPic = senderProPic;
    }
    return self;
}

@end
