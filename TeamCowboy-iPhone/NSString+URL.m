//
//  NSString+URL.m
//  TeamCowboy-iPhone
//
//  Created by Qian Han on 8/13/14.
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

//
//
+ (NSString *)stringByUrlEncodingString:(NSString *)inputString
{
    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                  (CFStringRef)inputString,
                                                                                  NULL,
                                                                                  (CFStringRef)@";/?:@&=$+{}<>,",
                                                                                  CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

@end
