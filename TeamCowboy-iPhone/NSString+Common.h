//
//  NSString+Common.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

@interface NSString (Common)

/**
 @brief Generates the SHA1 hash of the string.
 @param inputString The string to generate the hash from.
 @return The SHA1 hash.
 */
 + (NSString *)sha1FromString:(NSString *)inputString;

/**
 @brief Returns YES if the string only contains whitespace characters. NO otherwise.
 */
- (BOOL)isOnlyWhitespace;

/**
 @brief Returns the last character of the array.
 */
- (NSString *)lastCharacter;

@end
