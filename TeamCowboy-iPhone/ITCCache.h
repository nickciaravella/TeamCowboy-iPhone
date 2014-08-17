//
//  ITCCache.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

@interface ITCCache : NSObject

/**
 @brief Caches a dictionary for a fixed duration.
 @param dictionary The dictionary to be cached.
 @param duration   The number of minutes to cache the item.
 @param identifier The identifier that will be used to retrieve the item.
 @return Any error in caching the item.
 */
- (NSError *)addDictionary:(NSDictionary *)dictionary
        forNumberOfMinutes:(NSUInteger)duration
            withIdentifier:(NSString *)identifier;

/**
 @brief Retrieves a dictionary from the cache.
 @param identifier The identifier of the item.
 @param error      Contains an error if one exists.
 @return The dictionary containing the cached contents.
 */
- (NSDictionary *)dictionaryFromCacheIdentifier:(NSString *)identifier
                                          error:(NSError **)error;

@end
