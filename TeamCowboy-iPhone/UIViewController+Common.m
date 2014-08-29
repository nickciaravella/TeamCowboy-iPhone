//
//  UIViewController+Common.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

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

//
//
- (BOOL)openUrlForMapWithLocation:(NSString *)location
{
    return [self openUrlWithAbsoluteString:[NSString stringWithFormat:@"http://maps.apple.com/?q=%@", [NSString stringByUrlEncodingString:location]]];
}

@end
