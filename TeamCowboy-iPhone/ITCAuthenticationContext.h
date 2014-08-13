//
//  ITCAuthenticationContext.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCSerializableObject.h"

@interface ITCAuthenticationContext : ITCSerializableObject

/**
 @brief The user identifier
 */
@property (nonatomic, readonly) NSUInteger userId;

/**
 @brief The user's authentication token.
 */
@property (nonatomic, readonly) NSString *token;

@end
