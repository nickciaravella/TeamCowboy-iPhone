//
//  ITCAuthenticationProvider.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

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
 @brief The token of the currently authenticated user.
 */
@property (nonatomic, readonly) NSString *token;

/**
 @brief The identifier of the currently authenticated user.
 */
@property (nonatomic, readonly) NSUInteger userId;

/**
 @brief Returns YES if a user is currently logged in, NO otherwise.
 */
@property (nonatomic, readonly) BOOL isUserAuthenticated;

@end
