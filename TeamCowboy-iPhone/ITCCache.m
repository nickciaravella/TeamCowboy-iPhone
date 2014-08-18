//
//  ITCCache.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCCache.h"

#pragma mark - Constants

NSString *const kITCCacheItemExpirationDateKey = @"expirationDate";
NSString *const kITCCacheItemBodyKey           = @"body";

#pragma mark - ITCCache (implementation)

@implementation ITCCache

#pragma mark - ITCCache

//
//
- (NSError *)addCacheItem:(id)cacheItem
    forNumberOfMinutes:(NSUInteger)duration
        withIdentifier:(NSString *)identifier
{
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:( duration * 60 )];
    NSDictionary *cacheDictionary = @{
                                      kITCCacheItemExpirationDateKey : @([expirationDate timeIntervalSince1970]),
                                      kITCCacheItemBodyKey           : cacheItem
                                      };
    
    return [[ITCAppFactory fileService] writeDictionary:cacheDictionary
                                                 toFile:[self filePathForIdentifier:identifier]];
}

//
//
- (id)cachedItemFromCacheIdentifier:(NSString *)identifier
                              error:(NSError **)error
{
    if ( !error )
    {
        return nil;
    }
    
    NSDictionary *cacheDictionary = [[ITCAppFactory fileService] dictionaryFromFile:[self filePathForIdentifier:identifier]
                                                                              error:error];
    ITCLogAndReturnValueOnError(*error, nil, @"Cache received an error reading from the file system.");
    
    NSUInteger expirationTime = [cacheDictionary[ kITCCacheItemExpirationDateKey ] unsignedIntegerValue];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if ( expirationTime < now )
    {
        NSString *message = [NSString stringWithFormat:@"Cache item expired. Identifier: %@, Expiration: %lu, Now: %f", identifier, expirationTime, now];
        *error = [NSError errorWithCode:ITCErrorCacheItemExpired message:message];
        return nil;
    }
    
    return cacheDictionary[ kITCCacheItemBodyKey ];
}

#pragma mark - Private

//
//
- (NSURL *)filePathForIdentifier:(NSString *)identifier
{
    NSString *fileName = [NSString stringWithFormat:@"%@.plist", identifier];
    return [[[ITCAppFactory fileService] cacheDirectory] URLByAppendingPathComponent:fileName];
}

@end
