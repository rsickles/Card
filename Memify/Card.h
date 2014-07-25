//
//  Card.h
//  Memify
//
//  Created by Ryan Sickles on 7/23/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *senderProPic;
@property (nonatomic, copy) NSString *senderName;

- (instancetype)initWithName:(NSString *)senderName image:(UIImage *)image image:(UIImage *)senderProPic;
@end
