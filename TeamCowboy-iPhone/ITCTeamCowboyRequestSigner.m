//
//  ITCTeamCowboyRequestSigner.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCTeamCowboyRequestSigner.h"

@implementation ITCTeamCowboyRequestSigner

#pragma mark - ITCTeamCowboyRequestSigner

//
//
+ (NSString *)requestSignatureWithPrivateKey:(NSString *)privateKey
                                  httpMethod:(NSString *)httpMethod
                            teamCowboyMethod:(NSString *)teamCowboyMethod
                                   timestamp:(NSString *)timestamp
                                       nonce:(NSString *)nonce
                           requestParameters:(NSDictionary *)requestParameters
{
    NSString *concatenatedRequestString = [self concatenatedRequestStringFromParameters:requestParameters];
    NSLog(@"%@",concatenatedRequestString);
    
    NSMutableString *concatenatedString = [NSMutableString new];
    [concatenatedString appendFormat:@"%@|%@|%@|%@|%@|%@",
     privateKey, httpMethod, teamCowboyMethod, timestamp, nonce, concatenatedRequestString];
 
    return [NSString sha1FromString:concatenatedString];
}

#pragma mark - Private methods

//
// Creates the concatenated request string as detailed here: http://api.teamcowboy.com/v1/docs/#_Toc372547907
//
+ (NSString *)concatenatedRequestStringFromParameters:(NSDictionary *)parameters
{
    NSArray *sortedKeys = [[parameters allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableString *concatenatedRequest = [NSMutableString new];
    for (NSString *key in sortedKeys)
    {
        NSString *encodedValue = [NSString stringByUrlEncodingString:parameters[key]];
        [concatenatedRequest appendFormat:@"%@=%@&", [key lowercaseString], [encodedValue lowercaseString]];
    }

    // Remove extra appended &
    return [concatenatedRequest stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&"]];
}

@end
