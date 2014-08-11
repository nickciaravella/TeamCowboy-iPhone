//
//  UIViewController+Common.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "UIViewController+Common.h"

@implementation UIViewController (Common)

//
//
- (BOOL)openUrlWithAbsoluteString:(NSString *)urlString
{
    NSLog(@"Opening URL: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        return [[UIApplication sharedApplication] openURL:url];
    }
    return NO;
}

@end
