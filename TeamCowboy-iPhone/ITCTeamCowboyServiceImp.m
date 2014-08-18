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
    NSString *httpMethod = @"POST";
    NSString *requestString = [self requestStringForHttpMethod:httpMethod
                                              teamCowboyMethod:method
                                                withParameters:body];
    
    // 4. Make request
    NSURL *url = [NSURL URLWithString:@"https://api.teamcowboy.com/v1/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = httpMethod;
    request.HTTPBody   = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [self responseAfterSendingRequest:request
                                   forMethod:method
                             usingSerializer:serializer
                                   withError:error];
}

//
//
- (id)getRequestWithMethod:(NSString *)method
           queryParameters:(NSDictionary *)parameters
   usingResponseSerializer:(id<ITCObjectSerializer>)serializer
                     error:(NSError **)error
{
    NSString *httpMethod = @"GET";
    NSString *requestString = [self requestStringForHttpMethod:httpMethod
                                              teamCowboyMethod:method
                                                withParameters:parameters];
    
    // 4. Make request
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.teamcowboy.com/v1/?%@", requestString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = httpMethod;
    
    return [self responseAfterSendingRequest:request
                                   forMethod:method
                             usingSerializer:serializer
                                   withError:error];
}

#pragma mark - Private

//
//
- (NSString *)requestStringForHttpMethod:(NSString *)httpMethod
                        teamCowboyMethod:(NSString *)teamCowboyMethod
                          withParameters:(NSDictionary *)methodParameters
{
    // 1. Add required parameters
    NSString *nonce        = [[NSUUID UUID] UUIDString];
    NSString *timestamp    = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    
    NSMutableDictionary *requestParameters = [@{ @"api_key"       : kITCTeamCowboyPublicApiKey,
                                                 @"method"        : teamCowboyMethod,
                                                 @"timestamp"     : timestamp,
                                                 @"nonce"         : nonce,
                                                 @"response_type" : @"json" } mutableCopy];
    [requestParameters addEntriesFromDictionary:methodParameters];
    
    // 2. Sign and create the request string
    NSString *requestString = [self concatenatedRequestStringFromParameters:requestParameters];
    
    NSString *signatureInput = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@",
                                kITCTeamCowboyPrivateApiKey, httpMethod, teamCowboyMethod, timestamp, nonce, [requestString lowercaseString]];
    NSString *signature = [NSString sha1FromString:signatureInput];
    
    return [requestString stringByAppendingQueryParameterWithKey:@"sig" value:signature];
}

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

//
//
- (id)responseAfterSendingRequest:(NSURLRequest *)request
                        forMethod:(NSString *)method
                  usingSerializer:(id<ITCObjectSerializer>)serializer
                        withError:(NSError **)error
{
    NSHTTPURLResponse *response = nil;
    NSData *responseContent = [[ITCAppFactory httpConnection] sendRequest:request
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
        
        NSError *serializationError = nil;
        ITCTeamCowboyError *teamCowboyError = [errorSerializer serializedObjectFromData:responseContent
                                                                                  error:&serializationError];
        if ( serializationError )
        {
            NSString *message = [NSString stringWithFormat:@"Error during request. method: %@, http status: %li", method, response.statusCode];
            NSUInteger errorCode = ITCErrorUndefined;
            if ( response.statusCode >= 400 && response.statusCode < 500 )
            {
                errorCode = ITCErrorGenericClientError;
            }
            else if ( response.statusCode >= 500 )
            {
                errorCode = ITCErrorGenericServerError;
            }
            *error = [NSError errorWithCode:errorCode
                                 childError:serializationError
                                    message:message];
        }
        *error = ( *error ) ? *error : teamCowboyError.error;
        return nil;
    }
}

@end
