//
//  ITCEventRsvp.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCSerializableObject.h"

typedef NS_ENUM(NSInteger, ITCEventRsvpStatus)
{
    ITCEventRsvpStatusUnknown = 0,
    ITCEventRsvpStatusYes,
    ITCEventRsvpStatusNo,
    ITCEventRsvpStatusMaybe,
    ITCEventRsvpStatusAvailable,
    ITCEventRsvpStatusNoResponse,
};

@interface ITCEventRsvp : ITCSerializableObject

@property (nonatomic, readonly) NSString *userId;
@property (nonatomic, readonly) ITCEventRsvpStatus status;

@end
