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
    if ( username.length == 0 || password.length == 0 )
    {
        return [NSError errorWithCode:ITCErrorInvalidArgument
                              message:@"Username or password is invalid."];
    }
    
    NSError *responseError = nil;
    NSDictionary *requestBody = @{ @"username" : username,
                                   @"password" : password };
    id<ITCObjectSerializer> serializer = [ITCTeamCowboyEntitySerializer serializerForClass:[ITCAuthenticationContext class]
                                                                              isCollection:NO];
    self.authenticationContext = [[ITCAppFactory teamCowboyService] securePostRequestWithPath:@"Auth_GetUserToken"
                                                                                  requestBody:requestBody
                                                                      usingResponseSerializer:serializer
                                                                                        error:&responseError];
    if ( responseError )
    {
        return responseError;
    }

    return nil;
}

@end
