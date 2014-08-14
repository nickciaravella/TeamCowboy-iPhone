//
//  ITCError.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

typedef NS_ENUM(NSUInteger, ITCError)
{
    ITCErrorUndefined,
    ITCErrorInvalidArgument,
    ITCErrorObjectSerialization,   // Failure during object serialization
    ITCErrorGenericTeamCowboyError // Generic error from Team Cowboy service
};