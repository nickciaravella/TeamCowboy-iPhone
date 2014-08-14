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
    NSData *data = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

//
//
- (BOOL)isOnlyWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
}

//
//
- (NSString *)lastCharacter
{
    if (self.length == 0)
    {
        return @"";
    }
    return [self substringFromIndex:self.length - 1];
}

@end
