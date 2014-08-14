//
//  NSString+Common.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (Common)

//
//
+ (NSString *)sha1FromString:(NSString *)inputString
{
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSData *stringBytes = [inputString dataUsingEncoding: NSUTF8StringEncoding];
    CC_SHA1([stringBytes bytes], (CC_LONG)[stringBytes length], digest);
    return [[NSString alloc] initWithBytes:digest length:sizeof(digest) encoding:NSUTF8StringEncoding];
}

//
//
- (BOOL)isOnlyWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
}

@end
