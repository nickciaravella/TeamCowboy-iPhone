//
//  ITCAuthenticationProviderImp.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAuthenticationProviderImp.h"

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
    NSDictionary *response = [[ITCAppFactory teamCowboyService] securePostRequestWithPath:@"Auth_GetUserToken"
                                                                                     body:requestBody
                                                                                    error:&responseError];
    if ( responseError )
    {
        return responseError;
    }
    
    self.userId = [response[@"userId"] unsignedIntegerValue];
    self.token  = response[@"token"];

    return nil;
}

//
//
- (BOOL)isUserAuthenticated
{
    return self.userId && self.token;
}

@end
