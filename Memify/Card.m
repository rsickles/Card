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

- (instancetype)initWithName:senderName image:senderProPic image:mediaData message:message timeSent:timeSent mediaType:mediaType
{
    self = [super init];
    if (self) {
        _senderName = senderName;
        _senderProPic = senderProPic;
        _mediaData = mediaData;
        _message = message;
        _timeSent = timeSent;
        _mediaType = mediaType;
    }
    return self;
}

@end
