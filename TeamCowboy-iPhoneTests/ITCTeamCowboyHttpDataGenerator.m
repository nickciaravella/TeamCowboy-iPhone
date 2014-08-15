//
//  ITCTeamCowboyHttpDataGenerator.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCTeamCowboyHttpDataGenerator.h"

@implementation ITCTeamCowboyHttpDataGenerator

+ (NSData *)dataForSuccessResponseWithEntity:(NSDictionary *)entity
{
    NSDictionary *jsonDictionary = @{
                                     @"success" : @(YES),
                                     @"body"    : entity
                                     };
    return [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                           options:NSJSONWritingPrettyPrinted
                                             error:nil];
}

@end
