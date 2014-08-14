//
//  NSString+URL.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

@interface NSString (URL)

/**
 @brief URL encodes a string. This conforms to the RFC 3986 standard.
 @param inputString The string to be encoded
 @return The encoded sting.
 */
+ (NSString *)stringByUrlEncodingString:(NSString *)inputString;

/**
 @brief Appends a query parameter to the current string. It is assumed that the '?' is already present.
 @param key   The query parameter key
 @param value The query parameter value
 @return A new string that includes the appended query parameter.
 */
- (NSString *)stringByAppendingQueryParameterWithKey:(NSString *)key
                                               value:(NSString *)value;

@end
