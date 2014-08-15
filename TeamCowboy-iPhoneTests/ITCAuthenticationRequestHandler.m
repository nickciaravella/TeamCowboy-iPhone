//
//  ITCAuthenticationRequestHandler.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAuthenticationRequestHandler.h"
#import "ITCTeamCowboyHttpDataGenerator.h"

@implementation ITCAuthenticationRequestHandler

- (BOOL)canHandleMethod:(NSString *)method
{
    return [method isEqualToString:@"Auth_GetUserToken"];
}

- (NSData *)dataForRequest:(NSURLRequest *)request
                withMethod:(NSString *)teamCowboyMethod
         requestParameters:(NSDictionary *)requestParameters
         returningResponse:(NSHTTPURLResponse **)response
                     error:(NSError **)error
{
    self.count_timesCalled++;
    self.param_urlRequest = request;
    self.param_username   = requestParameters[ @"username" ];
    self.param_password   = requestParameters[ @"password" ];
    
    *response = self.return_response;
    *error    = self.return_httpError;
    
    return self.return_responseData;
}

- (void)setAuthContextWithUserId:(NSString *)userId
                           token:(NSString *)token
{
    self.return_responseData = [ITCTeamCowboyHttpDataGenerator
                                dataForSuccessResponseWithEntity:[self authContextDictionaryWithUserId:userId
                                                                                                 token:token]];
}

- (void)setTeamCowboyErrorWithCode:(NSString *)code message:(NSString *)message
{
    
}


- (NSDictionary *)authContextDictionaryWithUserId:(NSString *)userId
                                            token:(NSString *)token
{
    NSMutableDictionary *authContextDictionary = [NSMutableDictionary new];
    if ( userId )
    {
        [authContextDictionary setObject:userId forKey:@"userId"];
    }
    if ( token )
    {
        [authContextDictionary setObject:token forKey:@"token"];
    }
    return authContextDictionary;
}

@end
