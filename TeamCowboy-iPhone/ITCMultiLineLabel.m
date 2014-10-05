//
//  ITCMultiLineLabel.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCMultiLineLabel.h"

@implementation ITCMultiLineLabel

//
//
- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    CGFloat width = CGRectGetWidth(bounds);
    if (self.preferredMaxLayoutWidth != width)
    {
        self.preferredMaxLayoutWidth = width;
    }
}

@end
