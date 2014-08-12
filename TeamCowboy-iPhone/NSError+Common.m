//
//  NSError+Common.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "NSError+Common.h"

@implementation NSError (Common)

//
//
+ (NSError *)errorWithCode:(NSUInteger)code
                   message:(NSString *)message
{
    return [NSError errorWithDomain:@"TeamCowboy-iPhone" code:code userInfo:@{ @"message" : message }];
}

@end
