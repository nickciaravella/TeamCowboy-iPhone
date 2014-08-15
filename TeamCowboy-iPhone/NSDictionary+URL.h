//
//  NSDictionary+URL.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (URL)

/**
 @brief Creates a dictionary from a URL query. 
 @note  This method does not URL decode the the values.
 */
+ (NSDictionary *)dictionaryFromURLQuery:(NSString *)query;

@end
