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

    if ( !self.return_authContext )
    {
        return nil;
    }
    
    return [ITCTeamCowboyHttpDataGenerator
            dataForSuccessResponseWithEntity:[self authContextDictionaryWithUserId:self.return_authContext.userId
                                                                             token:self.return_authContext.token]];
}

- (void)setAuthContextWithUserId:(NSString *)userId
                           token:(NSString *)token
{
    self.return_authContext = [[ITCAuthenticationContext alloc]
                               initWithDictionary:[self authContextDictionaryWithUserId:userId
                                                                                  token:token]];
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
