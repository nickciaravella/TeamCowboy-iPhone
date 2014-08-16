//
//  ITCAuthenticationProvider.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAuthenticationContext.h"

@protocol ITCAuthenticationProvider <NSObject>

/**
 @brief Authenticates a user.
 @param username The user's username.
 @param password The user's password
 @return An error if the call fails.
 */
- (NSError *)authenticateUserWithUsername:(NSString *)username
                                 password:(NSString *)password;

/**
 Removes the currently logged in user's authentication context.
 */
- (void)removeAuthentication;

/** 
 @brief Context for the currently logged in user. 
 */
@property (nonatomic, readonly) ITCAuthenticationContext *authenticationContext;

@end
