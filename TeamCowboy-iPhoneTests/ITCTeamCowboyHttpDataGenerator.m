//
//  ITCTeamCowboyHttpDataGenerator.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCTeamCowboyHttpDataGenerator.h"

@implementation ITCTeamCowboyHttpDataGenerator

//
//
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

//
//
+ (NSData *)dataForErrorResponseWithCode:(NSString *)code
                                 message:(NSString *)message
                              httpStatus:(NSString *)httpStatus
{
    NSMutableDictionary *errorObject = [NSMutableDictionary new];
    if ( code )       [errorObject setObject:code forKey:@"errorCode"];
    if ( message )    [errorObject setObject:message forKey:@"message"];
    if ( httpStatus ) [errorObject setObject:httpStatus forKey:@"httpResponse"];
    
    NSDictionary *jsonDictionary = @{
                                     @"success" : @(NO),
                                     @"body"    : @{ @"error" : errorObject }
                                     };
    return [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                           options:NSJSONWritingPrettyPrinted
                                             error:nil];
}

//
//
+ (NSURL *)teamCowboySecureUrl
{
    return [NSURL URLWithString:@"https://api.teamcowboy.com/v1/"];
}

@end
