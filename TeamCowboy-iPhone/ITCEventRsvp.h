//
//  ITCEventRsvp.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCSerializableObject.h"
#import "ITCUser.h"

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
 @brief Helper method for converting a status to a log-friendly string.
 */
NSString *NSStringFromRsvpStatus(ITCEventRsvpStatus status);

/**
 @brief An RSVP given by a user.
 */
@interface ITCEventRsvp : ITCSerializableObject

@property (nonatomic, readonly) ITCUser *user;
@property (nonatomic, readonly) ITCEventRsvpStatus status;
@property (nonatomic, readonly) NSString *comments;

@end
