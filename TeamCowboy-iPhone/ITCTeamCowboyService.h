//
//  ITCTeamCowboyService.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

@protocol ITCTeamCowboyService <NSObject>

/**
 @brief Makes a secure POST request to the Team Cowboy service.
 @param path  The path of the resource to access.
 @param body  The body of the request.
 @param error If the call results in an error, this value will be set to the error and the return value will be nil.
 @return The service's response.
 */
- (NSDictionary *)securePostRequestWithPath:(NSString *)path
                                       body:(NSDictionary *)body
                                      error:(NSError **)error;

@end
