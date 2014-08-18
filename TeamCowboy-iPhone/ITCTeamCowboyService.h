//
//  ITCTeamCowboyService.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCObjectSerializer.h"

@protocol ITCTeamCowboyService <NSObject>

/**
 @brief Makes a secure POST request to the Team Cowboy service.
 @param method     The Team Cowboy method be called.
 @param body       The body of the request.
 @param serializer The serializer to use to parse successful responses.
 @param error      If the call results in an error, this value will be set to the error and the return value will be nil.
 @return The service's serialized response.
 */
- (id)securePostRequestWithMethod:(NSString *)method
                      requestBody:(NSDictionary *)body
          usingResponseSerializer:(id<ITCObjectSerializer>)serializer
                            error:(NSError **)error;

/**
 @brief Makes a GET request to the Team Cowboy service.
 @param method     The Team Cowboy method being called.
 @param parameters The parameters to the method being called.
 @param serializer The serializer to use to parse successful responses.
 @param error      If the call results in an error, this value will be set to the error and the return value will be nil.
 @return The service's serialized response.
 */
- (id)getRequestWithMethod:(NSString *)method
           queryParameters:(NSDictionary *)parameters
   usingResponseSerializer:(id<ITCObjectSerializer>)serializer
                     error:(NSError **)error;

@end
