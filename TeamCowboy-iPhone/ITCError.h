//
//  ITCError.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

typedef NS_ENUM(NSUInteger, ITCError)
{
    ITCErrorUndefined = 1,
    ITCErrorInvalidArgument,
    ITCErrorGenericClientError,      // Non-specific 400 level error
    ITCErrorGenericServerError,      // Non-specific 500 level error
    ITCErrorObjectSerialization,     // Failure during object serialization
    ITCErrorGenericTeamCowboyError,  // Generic error from Team Cowboy service
};