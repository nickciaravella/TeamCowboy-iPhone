//
//  ITCSaveRsvpResponse.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCSaveRsvpResponse.h"

@implementation ITCSaveRsvpResponse

//
//
+ (NSDictionary *)propertyToKeyPathMapping
{
    return @{
             @"isRsvpSaved" : @"rsvpSaved",
             @"statusCode"  : @"statusCode"
             };
}

@end
