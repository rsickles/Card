//
//  MediaTypeButton.h
//  Memify
//
//  Created by Ryan Sickles on 7/28/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaTypeButton : NSObject


@property (nonatomic, strong) UIImage *mediaImage;
@property (nonatomic, copy) NSString *mediaType;

- (instancetype)initWithName:(NSString *)mediaType mediaImage:(UIImage *)mediaImage;


@end
