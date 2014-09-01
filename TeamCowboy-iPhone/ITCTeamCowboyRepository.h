//
//  ITCTeamCowboyRepository.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

@interface ITCTeamCowboyRepository : NSObject

/**
 @brief Posts an action to the Team Cowboy service.
 @param type             The response type from the server.
 @param teamCowboyMethod The method bing performed.
 @param parameters       The parameters to the method
 @param error            If an error occurs, it will be put into this object.
 @return The response entity.
 */
+ (id)postEntityWithResultingType:(Class)type
              forTeamCowboyMethod:(NSString *)teamCowboyMethod
                   withParameters:(NSDictionary *)parameters
                            error:(NSError **)error;

/**
 @brief Gets an entity from either a cache or the Team Cowboy service.
 @param type             The type of entity. It should be a subclass of ITCSerializableObject.
 @param cacheIdentifier  The identifier of the cached item.
 @param teamCowboyMethod The method to call in the Team Cowboy service.
 @param parameters       Parameters to the Team Cowboy method.
 @param duration         The length to store the item in the cache.
 @param error            If an error occurs, it will be put into this object.
 @return The entity.
 */
+ (id)getEntityOfType:(Class)type
  withCacheIdentifier:(NSString *)cacheIdentifier
     teamCowboyMethod:(NSString *)teamCowboyMethod
      queryParameters:(NSDictionary *)parameters
        cacheDuration:(NSUInteger)duration
                error:(NSError **)error;

/**
 @brief Gets a collection of entities from either a cache or the Team Cowboy service.
 @param type             The type of entity in the collection. It should be a subclass of ITCSerializableObject.
 @param cacheIdentifier  The identifier of the cached item.
 @param teamCowboyMethod The method to call in the Team Cowboy service.
 @param parameters       Parameters to the Team Cowboy method.
 @param duration         The length to store the item in the cache.
 @param error            If an error occurs, it will be put into this object.
 @return The entity.
 */
+ (id)getCollectionOfEntitiesOfType:(Class)type
                withCacheIdentifier:(NSString *)cacheIdentifier
                   teamCowboyMethod:(NSString *)teamCowboyMethod
                    queryParameters:(NSDictionary *)parameters
                      cacheDuration:(NSUInteger)duration
                              error:(NSError **)error;

@end
