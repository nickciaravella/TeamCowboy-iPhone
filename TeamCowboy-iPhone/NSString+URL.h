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

@end
