//
//  ITCEvent.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCSerializableObject.h"
#import "ITCEventAttendanceList.h"
#import "ITCEventRsvp.h"

/**
 @brief An event, such as a game, practice or meetup.
 */
@interface ITCEvent : ITCSerializableObject

@property (nonatomic, readonly) NSNumber *eventId;
@property (nonatomic, readonly) NSString *teamName;
@property (nonatomic, readonly) NSString *opponentName;
@property (nonatomic, readonly) NSString *locationName;
@property (nonatomic, readonly) NSString *locationAddress;
@property (nonatomic, readonly) NSDate   *eventDate;
@property (nonatomic, readonly) NSString *homeAway;
@property (nonatomic, readonly) ITCEventAttendanceList *attendanceList;

/**
 @brief Loads the RSVPs for an event. After this call, if there is no error, the "attendanceList" property will be populated.
 @param bypassCache YES if cached values should be ignored.
 @param error If an error occurs, it will be put into this variable.
 */
- (void)loadAttendanceListBypassingCache:(BOOL)bypassCache
                               withError:(NSError **)error;

@end
