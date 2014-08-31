//
//  ITCEventRsvp.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCSerializableObject.h"

/**
 @brief An RSVP status
 */
typedef NS_ENUM(NSInteger, ITCEventRsvpStatus)
{
    ITCEventRsvpStatusUnknown = 0,
    ITCEventRsvpStatusYes,
    ITCEventRsvpStatusNo,
    ITCEventRsvpStatusMaybe,
    ITCEventRsvpStatusAvailable,
    ITCEventRsvpStatusNoResponse,
};

/**
 @brief An RSVP given by a user.
 */
@interface ITCEventRsvp : ITCSerializableObject

@property (nonatomic, readonly) NSString *userId;
@property (nonatomic, readonly) ITCEventRsvpStatus status;

@end
