//
//  ITCEvent.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCSerializableObject.h"
#import "ITCEventRsvp.h"

@interface ITCEvent : ITCSerializableObject

@property (nonatomic, readonly) NSNumber *eventId;
@property (nonatomic, readonly) NSString *teamName;
@property (nonatomic, readonly) NSString *opponentName;
@property (nonatomic, readonly) NSString *locationName;
@property (nonatomic, readonly) NSString *locationAddress;
@property (nonatomic, readonly) NSDate   *eventDate;
@property (nonatomic, readonly) NSString *homeAway;
@property (nonatomic, readonly) ITCEventRsvp *currentRsvp;

/**
 @brief Loads the event, including the current user's RSVP status.
 @param bypassCache YES if cached values should be ignored.
 @param error If an error occurs, it will be put into this variable.
 @return A new event object.
 */
- (ITCEvent *)loadCurrentRsvpStatusBypassingCache:(BOOL)bypassCache
                                        withError:(NSError **)error;

@end
