//
//  ITCTeamCowboyService.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCObjectSerializer.h"

@protocol ITCTeamCowboyService <NSObject>

/**
 @brief Makes a secure POST request to the Team Cowboy service.
 @param path       The path of the resource to access.
 @param body       The body of the request.
 @param serializer The serializer to use to parse successful responses.
 @param error      If the call results in an error, this value will be set to the error and the return value will be nil.
 @return The service's serialized response.
 */
- (id)securePostRequestWithPath:(NSString *)path
                    requestBody:(NSDictionary *)body
        usingResponseSerializer:(id<ITCObjectSerializer>)serializer
                          error:(NSError **)error;

@end
