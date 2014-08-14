//
//  NSString+URL.m
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

//
//
- (NSString *)stringByAppendingQueryParameterWithKey:(NSString *)key
                                               value:(NSString *)value
{
    if ( self.isOnlyWhitespace || [self.lastCharacter isEqualToString:@"&"] )
    {
        return [NSString stringWithFormat:@"%@%@=%@", self, key, value];
    }
    else
    {
        return [NSString stringWithFormat:@"%@&%@=%@", self, key, value];        
    }
}

@end
