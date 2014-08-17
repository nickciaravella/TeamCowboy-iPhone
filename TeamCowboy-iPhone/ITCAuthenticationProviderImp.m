//
//  ITCAuthenticationProviderImp.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAuthenticationProviderImp.h"
#import "ITCTeamCowboyEntitySerializer.h"

@implementation ITCAuthenticationProviderImp

#pragma mark - NSObject

//
//
- (id)init
{
    if (!(self = [super init])) { return nil; }
    
    NSError *error = nil;
    NSDictionary *contextDictionary = [[ITCAppFactory fileService] dictionaryFromFile:[self persistedContextPath]
                                                                                error:&error];
    if ( error )
    {
        ITCLog(@"Failed to read auth context with error: %@", error);
        return self;
    }
    
    _authenticationContext = [[ITCAuthenticationContext alloc] initWithDictionary:contextDictionary];
    
    return self;
}

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
    
    // No error, but there is data missing. Treat it as an error.
    if ( !responseError &&
         ( self.authenticationContext.token.length == 0 || self.authenticationContext.userId.length == 0 ))
    {
        NSString *message = [NSString stringWithFormat:@"Server did not return a token (%@) or a userId (%@)",
                             self.authenticationContext.token, self.authenticationContext.userId];
        responseError = [NSError errorWithCode:ITCErrorGenericServerError message:message];
        self.authenticationContext = nil;
    }
    
    // No error, cache the authentication context
    if ( !responseError )
    {
        [[ITCAppFactory fileService] writeDictionary:[self.authenticationContext dictionaryFormat]
                                              toFile:[self persistedContextPath]];
    }
    
    return responseError;
}

//
//
- (void)removeAuthentication
{
    [[ITCAppFactory fileService] deleteFile:[self persistedContextPath]];
    self.authenticationContext = nil;
}

#pragma mark - Private
                                                      
//
//
- (NSURL *)persistedContextPath
{
    return [[[ITCAppFactory fileService] applicationSupportDirectory] URLByAppendingPathComponent:@"authenticationContext.plist"];
}
                                                      
@end
