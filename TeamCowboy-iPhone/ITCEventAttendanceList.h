//
//  ITCEventAttendanceList.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCSerializableObject.h"
#import "ITCEventRsvp.h"

/**
 @brief The attendance information for an event.
 */
@interface ITCEventAttendanceList : ITCSerializableObject

@property (nonatomic, readonly) NSArray *rsvps; // ITCEventRsvp

/**
 @brief Finds the number of RSVPs that match the given status.
 @param status The status
 @return The number of RSVPs
 */
- (NSUInteger)numberOfResponsesMatchingStatus:(ITCEventRsvpStatus)status;

@end
