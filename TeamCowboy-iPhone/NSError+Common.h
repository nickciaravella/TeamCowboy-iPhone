//
//  NSError+Common.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

@interface NSError (Common)

/**
 @brief Creates an error object with a message.
 @param code    The error code.
 @param message The message of the error.
 @return The initialized error object.
 */
+ (NSError *)errorWithCode:(NSUInteger)code
                   message:(NSString *)message;

/**
 @brief Creates an error object with a message.
 @param code       The error code.
 @param childError A child error.
 @param message    The message of the error.
 @return The initialized error object.
 */
+ (NSError *)errorWithCode:(NSUInteger)code
                childError:(NSError *)childError
                   message:(NSString *)message;

@end
