//
//  MediaTypeButton.m
//  Memify
//
//  Created by Ryan Sickles on 7/28/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "MediaTypeButton.h"

@implementation MediaTypeButton

- (instancetype)initWithName:(NSString *)mediaType mediaImage:(UIImage *)media_image{
    self = [super init];
    if (self) {
        _mediaType = mediaType;
        _mediaImage = media_image;
    }
    return self;
}

@end
