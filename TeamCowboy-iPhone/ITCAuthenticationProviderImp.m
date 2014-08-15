//
//  ITCAuthenticationProviderImp.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAuthenticationProviderImp.h"
#import "ITCTeamCowboyEntitySerializer.h"

@implementation ITCAuthenticationProviderImp

#pragma mark - ITCAuthenticationProviderImp

//
//
- (NSError *)authenticateUserWithUsername:(NSString *)username
                                 password:(NSString *)password
{
    if ( username.length == 0 ||
         username.isOnlyWhitespace ||
         password.length == 0 ||
         password.isOnlyWhitespace )
    {
        return [NSError errorWithCode:ITCErrorInvalidArgument
                              message:@"Username or password is invalid."];
    }
    
    NSError *responseError = nil;
    NSDictionary *requestBody = @{ @"username" : username,
                                   @"password" : password };
    id<ITCObjectSerializer> serializer = [ITCTeamCowboyEntitySerializer serializerForClass:[ITCAuthenticationContext class]
                                                                              isCollection:NO];
    self.authenticationContext = [[ITCAppFactory teamCowboyService] securePostRequestWithMethod:@"Auth_GetUserToken"
                                                                                    requestBody:requestBody
                                                                        usingResponseSerializer:serializer
                                                                                          error:&responseError];
    
    // No error, but there is data missing.
    if ( !responseError &&
         ( self.authenticationContext.token.length == 0 || self.authenticationContext.userId.length == 0 ))
    {
        NSString *message = [NSString stringWithFormat:@"Server did not return a token (%@) or a userId (%@)",
                             self.authenticationContext.token, self.authenticationContext.userId];
        responseError = [NSError errorWithCode:ITCErrorGenericServerError message:message];
        self.authenticationContext = nil;
    }
    
    return responseError;
}

@end
