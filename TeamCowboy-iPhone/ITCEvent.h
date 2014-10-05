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
@property (nonatomic, readonly) BOOL      isTimeTBD;
@property (nonatomic, readonly) NSString *homeAway;

@property (nonatomic, readonly) ITCEventAttendanceList *attendanceList;
@property (nonatomic, readonly) BOOL isAttendanceListLoaded;

/**
 @brief Loads the RSVPs for an event. After this call, if there is no error, the "attendanceList" property will be populated.
 @param bypassCache YES if cached values should be ignored.
 @return An error if one occurs.
 */
- (NSError *)loadAttendanceListBypassingCache:(BOOL)bypassCache;

/**
 @brief Saves an RSVP for the event for the current user.
 @param status The status to save for the user.
 @param additionalMales The number of additional males to include.
 @param additionalFemales The number of additional females to include.
 @param comments Comments for the RSVP. This is limited to 150 characters.
 @return An error if one occurs.
 */
- (NSError *)rsvpWithStatus:(ITCEventRsvpStatus)status
            additionalMales:(NSUInteger)additionalMales
          additionalFemales:(NSUInteger)additionalFemales
                   comments:(NSString *)comments;

@end
