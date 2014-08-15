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
    return responseError;
}

@end
