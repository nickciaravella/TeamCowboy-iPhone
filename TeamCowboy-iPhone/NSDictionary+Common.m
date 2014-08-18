//
//  NSDictionary+Common.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "NSDictionary+Common.h"

@implementation NSMutableDictionary (Common)

//
//
- (void)safeSetValue:(id)value forKey:(id)key
{
    if ( value )
    {
        [self setObject:value forKey:key];
    }
}

@end
