//
//  ITCCache.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

@interface ITCCache : NSObject

/**
 @brief Caches an item for a fixed duration.
 @param cacheItem  The item to be cached.
 @param duration   The number of minutes to cache the item.
 @param identifier The identifier that will be used to retrieve the item.
 @return Any error in caching the item.
 */
- (NSError *)addCacheItem:(id)cacheItem
       forNumberOfMinutes:(NSUInteger)duration
           withIdentifier:(NSString *)identifier;

/**
 @brief Retrieves a cached item from the cache.
 @param identifier The identifier of the item.
 @param error      Contains an error if one exists.
 @return The cached item.
 */
- (id)cachedItemFromCacheIdentifier:(NSString *)identifier
                              error:(NSError **)error;

@end
