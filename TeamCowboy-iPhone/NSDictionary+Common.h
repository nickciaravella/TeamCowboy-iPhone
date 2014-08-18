//
//  NSDictionary+Common.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Common)

/**
 @brief Sets the value for the key if object is not nil.
 @param value The value to set
 @param key   The key to set the value for
 */
- (void)safeSetValue:(id)value forKey:(id)key;

@end
