//
//  ITCTeamCowboyServiceImp.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCTeamCowboyServiceImp.h"
#import "ITCTeamCowboyEntitySerializer.h"
#import "ITCTeamCowboyError.h"

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
    NSData *responseContent = [NSURLConnection sendSynchronousRequest:request
                                                    returningResponse:&response
                                                                error:error];
    if ( *error )
    {
        return nil;
    }    
    
    // 5. Deserialize response to either entity or error
    if ( response.statusCode < 400 ) // Success: Use the entity serializer
    {
        return [serializer serializedObjectFromData:responseContent error:error];
    }
    else // Failure: Use the error serializer
    {
        id<ITCObjectSerializer> errorSerializer =  [ITCTeamCowboyEntitySerializer serializerForClass:[ITCTeamCowboyError class]
                                                                                        isCollection:NO];
        
        ITCTeamCowboyError *teamCowboyError = [errorSerializer serializedObjectFromData:responseContent
                                                                                  error:error];
        *error = ( *error ) ? *error : teamCowboyError.error;
        return nil;
    }
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
