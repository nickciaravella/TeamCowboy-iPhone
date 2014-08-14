//
//  ITCTeamCowboyServiceImp.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCTeamCowboyServiceImp.h"

@implementation ITCTeamCowboyServiceImp

#pragma mark - ITCTeamCowboyService

//
//
- (id)securePostRequestWithMethod:(NSString *)method
                      requestBody:(NSDictionary *)body
          usingResponseSerializer:(id<ITCObjectSerializer>)serializer
                            error:(NSError **)error
{
    // 1. Add required parameters
    NSString *nonce        = [[NSUUID UUID] UUIDString];
    NSString *timestamp    = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *httpMethod   = @"POST";
    
    NSMutableDictionary *requestParameters = [@{ @"api_key"       : kITCTeamCowboyPublicApiKey,
                                                 @"method"        : method,
                                                 @"timestamp"     : timestamp,
                                                 @"nonce"         : nonce,
                                                 @"response_type" : @"json" } mutableCopy];
    [requestParameters addEntriesFromDictionary:body];

    // 2. Sign and create the request string
    NSString *requestString = [self concatenatedRequestStringFromParameters:requestParameters];
    
    NSString *signatureInput = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@",
     kITCTeamCowboyPrivateApiKey, httpMethod, method, timestamp, nonce, [requestString lowercaseString]];
    NSString *signature = [NSString sha1FromString:signatureInput];

    requestString = [requestString stringByAppendingQueryParameterWithKey:@"sig" value:signature];
    
    // 4. Make request
    NSURL *url = [NSURL URLWithString:@"https://api.teamcowboy.com/v1/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = httpMethod;
    request.HTTPBody   = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSHTTPURLResponse *response = nil;
    NSError *httpError = nil;
    NSData *responseContent = [NSURLConnection sendSynchronousRequest:request
                                                    returningResponse:&response
                                                                error:&httpError];
    
    // 5. Deserialize response to dictionary
    NSError *jsonReadingError = nil;
    NSDictionary *objectDictionary = [NSJSONSerialization JSONObjectWithData:responseContent
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:&jsonReadingError];
    
    // 6. Deserialize response to either entity or error
    NSLog(@"%@", objectDictionary);
    return objectDictionary;
}

#pragma mark - Private

//
//
- (NSString *)concatenatedRequestStringFromParameters:(NSDictionary *)parameters
{
    NSArray *sortedKeys = [[parameters allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSString *concatenatedRequest = [NSString string];
    for (NSString *key in sortedKeys)
    {
        NSString *encodedValue = [NSString stringByUrlEncodingString:parameters[key]];
        concatenatedRequest = [concatenatedRequest stringByAppendingQueryParameterWithKey:key
                                                                                    value:encodedValue];
    }
    
    return concatenatedRequest;
}

@end
