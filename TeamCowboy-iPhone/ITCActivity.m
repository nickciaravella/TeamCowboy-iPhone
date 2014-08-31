//
//  ITCActivity.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCActivity.h"

@implementation ITCActivity

#pragma mark - ITCSerializableObject

//
//
+ (NSDictionary *)propertyToKeyPathMapping
{
    return @{
             @"activityId" : @"activityId",
             @"name"       : @"name"
             };
}

@end
