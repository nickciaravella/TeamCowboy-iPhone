//
//  ITCAuthenticationContext.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAuthenticationContext.h"

@implementation ITCAuthenticationContext

#pragma mark - ITCSerializableObject overrides

//
//
+ (NSDictionary *)propertyToKeyPathMapping
{
    return @{
             @"token"  : @"token",
             @"userId" : @"userId"
             };
}

@end
