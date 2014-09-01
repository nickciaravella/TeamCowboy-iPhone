//
//  ITCEvent.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCEvent.h"
#import "ITCTeamCowboyRepository.h"

#pragma mark - ITCEvent ()

@interface ITCEvent ()

@property (nonatomic, readonly) NSNumber *teamId;
@property (nonatomic, readonly) NSArray  *rsvps; // ITCEventRsvp
@property (nonatomic, readonly) NSString *serverEventDate;

@end

#pragma mark - ITCEvent (implementation)

@implementation ITCEvent

#pragma mark - ITCSerializableObject

//
//
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (!(self = [super initWithDictionary:dictionary])) { return nil; }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    _eventDate = [dateFormatter dateFromString:_serverEventDate];
    
    return self;
}

//
//
+ (NSDictionary *)propertyToKeyPathMapping
{
    return @{
             @"eventId"         : @"eventId",
             @"teamName"        : @"team.name",
             @"teamId"          : @"team.teamId",
             @"opponentName"    : @"title",
             @"homeAway"        : @"homeAway",
             @"locationAddress" : @"location.address.displaySingleLine",
             @"locationName"    : @"location.name",
             @"serverEventDate" : @"dateTimeInfo.startDateTimeLocal"
             };
}

//
//
+ (NSDictionary *)embeddedObjectPropertyToClassMapping
{
    return @{
             @"rsvps" : NSStringFromClass([ITCEventRsvp class])
             };
}

#pragma mark - ITCEvent

//
//
- (ITCEvent *)loadCurrentRsvpStatusBypassingCache:(BOOL)bypassCache
                                        withError:(NSError **)error
{
    return [ITCTeamCowboyRepository getEntityOfType:[ITCEvent class]
                                withCacheIdentifier:bypassCache ? nil : [NSString stringWithFormat:@"event_%@", self.eventId]
                                   teamCowboyMethod:@"Event_Get"
                                    queryParameters:@{
                                                      @"eventId" : [self.eventId description],
                                                      @"teamId"  : [self.teamId description],
                                                      @"includeRSVPInfo" : @"true"                                                      
                                                      }
                                      cacheDuration:60
                                              error:error];
}

//
//
- (void)loadAttendanceListBypassingCache:(BOOL)bypassCache
                               withError:(NSError **)error
{
    _attendanceList = [ITCTeamCowboyRepository getEntityOfType:[ITCEventAttendanceList class]
                                           withCacheIdentifier:bypassCache ? nil : [NSString stringWithFormat:@"eventAttendanceList_%@", self.eventId]
                                              teamCowboyMethod:@"Event_GetAttendanceList"
                                               queryParameters:@{
                                                                 @"eventId" : [self.eventId description],
                                                                 @"teamId"  : [self.teamId description]
                                                                 }
                                                 cacheDuration:60
                                                         error:error];
}

@end
