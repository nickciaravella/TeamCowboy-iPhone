//
//  ITCTeamCowboyRepository.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCTeamCowboyRepository.h"
#import "ITCTeamCowboyEntitySerializer.h"

@implementation ITCTeamCowboyRepository

#pragma mark - ITCTeamCowboyRepository

//
//
+ (id)getEntityOfType:(Class)type
   withCacheIdentifier:(NSString *)cacheIdentifier
      teamCowboyMethod:(NSString *)teamCowboyMethod
      queryParameters:(NSDictionary *)parameters
         cacheDuration:(NSUInteger)duration
                 error:(NSError **)error
{
    return [self getEntitiesOfType:type
                      isCollection:NO
               withCacheIdentifier:cacheIdentifier
                  teamCowboyMethod:teamCowboyMethod
                   queryParameters:parameters
                     cacheDuration:duration
                             error:error];
}

//
//
+ (id)getCollectionOfEntitiesOfType:(Class)type
                withCacheIdentifier:(NSString *)cacheIdentifier
                   teamCowboyMethod:(NSString *)teamCowboyMethod
                    queryParameters:(NSDictionary *)parameters
                      cacheDuration:(NSUInteger)duration
                              error:(NSError **)error
{
    return [self getEntitiesOfType:type
                      isCollection:YES
               withCacheIdentifier:cacheIdentifier
                  teamCowboyMethod:teamCowboyMethod
                   queryParameters:parameters
                     cacheDuration:duration
                             error:error];
}

#pragma mark - Private

//
//
+ (id)getEntitiesOfType:(Class)type
           isCollection:(BOOL)isCollection
    withCacheIdentifier:(NSString *)cacheIdentifier
       teamCowboyMethod:(NSString *)teamCowboyMethod
        queryParameters:(NSDictionary *)parameters
          cacheDuration:(NSUInteger)duration
                  error:(NSError **)error
{
    if ( !error ) { return nil; }
    ITCAuthenticationContext *authContext = [ITCAppFactory authenticationProvider].authenticationContext;
    
    if ( cacheIdentifier )
    {
        // First try to load the entity from the cache.
        NSError *cacheReadError = nil;
        id cachedItem = [[ITCAppFactory cache] cachedItemFromCacheIdentifier:cacheIdentifier
                                                                       error:&cacheReadError];
        if ( !cacheReadError )
        {
            if ( isCollection )
            {
                NSMutableArray *array = [NSMutableArray new];
                for ( NSDictionary *element in cachedItem )
                {
                    [array addObject:[[type alloc] initWithDictionary:element]];
                }
                return array;
            }
            else
            {
                return [[type alloc] initWithDictionary:cachedItem];
            }
        }
    }
    
    // Otherwise load the entity from the service
    if ( !authContext.token )
    {
        *error = [NSError errorWithCode:ITCErrorUserNotAuthenticated message:@"No user is currently authenticated."];
        return nil;
    }
    
    NSMutableDictionary *queryParameters = [[NSMutableDictionary alloc] initWithDictionary:@{ @"userToken" : authContext.token }];
    [queryParameters addEntriesFromDictionary:parameters];
    id entity =  [[ITCAppFactory teamCowboyService] getRequestWithMethod:teamCowboyMethod
                                                         queryParameters:queryParameters
                                                 usingResponseSerializer:[ITCTeamCowboyEntitySerializer serializerForClass:type isCollection:isCollection]
                                                                   error:error];
    if ( *error ) { return nil; }
    
    // If successful, add the entity to the cache.
    id cacheItem = nil;
    if ( isCollection )
    {
        NSMutableArray *cacheArray = [NSMutableArray new];
        for ( ITCSerializableObject *element in entity )
        {
            [cacheArray addObject:[element dictionaryFormat]];
        }
        cacheItem = cacheArray;
    }
    else
    {
        cacheItem = [entity dictionaryFormat];
    }
    NSError *cacheWriteError = [[ITCAppFactory cache] addCacheItem:cacheItem
                                       forNumberOfMinutes:duration
                                           withIdentifier:cacheIdentifier];

    ITCLogAndReturnValueOnError(cacheWriteError, entity, @"Failed to write the entity to the cache. Identifier: %@, entity: %@",
                                cacheIdentifier, entity);
    
    return entity;
}

@end
