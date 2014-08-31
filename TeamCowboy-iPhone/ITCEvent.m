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

@end

#pragma mark - ITCEvent (implementation)

@implementation ITCEvent

#pragma mark - ITCSerializableObject

//
//
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (!(self = [super initWithDictionary:dictionary])) { return nil; }
    
    _eventId         = dictionary[ @"eventId" ];
    _teamName        = dictionary[ @"team" ][ @"name" ];
    _teamId          = dictionary[ @"team" ][ @"teamId" ];
    _opponentName    = dictionary[ @"title" ];
    _homeAway        = dictionary[ @"homeAway" ];
    _locationAddress = dictionary[ @"location" ][ @"address" ][ @"displaySingleLine" ];
    _locationName    = dictionary[ @"location" ][ @"name" ];
    _rsvps           = [self rsvpsFromDictionaries:dictionary[ @"rsvpInstances" ]];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    _eventDate = [dateFormatter dateFromString:dictionary[ @"dateTimeInfo" ][ @"startDateTimeLocal" ]];
        
    return self;
}

//
//
- (NSDictionary *)dictionaryFormat
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    [dictionary safeSetValue:self.eventId forKey:@"eventId"];
    [dictionary safeSetValue:@{ @"name"   : self.teamName,
                                @"teamId" : self.teamId } forKey:@"team"];
    [dictionary safeSetValue:self.opponentName forKey:@"title"];
    [dictionary safeSetValue:self.homeAway forKey:@"homeAway"];
    [dictionary safeSetValue:@{ @"address" : @{ @"displaySingleLine" : self.locationAddress },
                                @"name"    : self.locationName }
                      forKey:@"location"];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [dictionary safeSetValue:@{ @"startDateTimeLocal" : [formatter stringFromDate:self.eventDate] }
                      forKey:@"dateTimeInfo"];
    
    return dictionary;
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
- (ITCEventAttendanceList *)loadAttendanceListBypassingCache:(BOOL)bypassCache
                                                   withError:(NSError **)error
{
    return [ITCTeamCowboyRepository getEntityOfType:[ITCEvent class]
                                withCacheIdentifier:bypassCache ? nil : [NSString stringWithFormat:@"eventAttendanceList_%@", self.eventId]
                                   teamCowboyMethod:@"Event_GetAttendanceList"
                                    queryParameters:@{
                                                      @"eventId" : [self.eventId description],
                                                      @"teamId"  : [self.teamId description]
                                                      }
                                      cacheDuration:60
                                              error:error];
}

//
//
- (ITCEventRsvp *)currentRsvp
{
    return [self.rsvps firstObject];
}

#pragma mark - Private

//
//
- (NSArray *)rsvpsFromDictionaries:(NSArray *)rsvpDictionaries
{
    NSMutableArray *rsvps = [NSMutableArray new];
    for (NSDictionary *rsvpDictionary in rsvpDictionaries)
    {
        [rsvps addObject:[[ITCEventRsvp alloc] initWithDictionary:rsvpDictionary]];
    }
    return rsvps;
}

@end
