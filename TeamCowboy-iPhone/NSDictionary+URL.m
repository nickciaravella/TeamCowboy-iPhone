//
//  NSDictionary+URL.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "NSDictionary+URL.h"

@implementation NSDictionary (URL)

//
//
+ (NSDictionary *)dictionaryFromURLQuery:(NSString *)query
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    NSArray *components = [query componentsSeparatedByString:@"&"];
    for (NSString *component in components)
    {
        NSArray *keyValue = [component componentsSeparatedByString:@"="];
        if ( [keyValue count] != 2 )
        {
            return nil;
        }
        [dictionary setObject:keyValue[1] forKey:keyValue[0]];
    }
    return dictionary;
}

@end
