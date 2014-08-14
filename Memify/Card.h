//
//  Card.h
//  Memify
//
//  Created by Ryan Sickles on 7/23/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, strong) UIImage *senderProPic;
@property (nonatomic, copy) NSString *senderName;
@property (nonatomic, copy) NSData *mediaData;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *timeSent;
@property (nonatomic, copy) NSData *mediaType;

- (instancetype)initWithName:senderName image:senderProPic image:mediaData message:message timeSent:timeSent mediaType:mediaType;
@end
