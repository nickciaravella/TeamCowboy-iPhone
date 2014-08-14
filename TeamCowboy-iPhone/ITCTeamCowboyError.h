//
//  ITCTeamCowboyError.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

/**
 @brief An error returned from the Team Cowboy service
 */
@interface ITCTeamCowboyError : ITCSerializableObject

/**
 @brief Returns a standard error object from the Team Cowboy error.
 */
- (NSError *)error;

@end
