//
//  ITCEvent.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCEvent.h"

@implementation ITCEvent

//
//
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (!(self = [super initWithDictionary:dictionary])) { return nil; }
    
    _eventId         = dictionary[ @"eventId" ];
    _teamName        = dictionary[ @"team" ][ @"name" ];
    _opponentName    = dictionary[ @"title" ];
    _homeAway        = dictionary[ @"homeAway" ];
    _locationAddress = dictionary[ @"location" ][ @"address" ][ @"displaySingleLine" ];
    _locationName    = dictionary[ @"location" ][ @"name" ];
    
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
    [dictionary safeSetValue:@{ @"name" : self.teamName } forKey:@"team"];
    [dictionary safeSetValue:self.opponentName forKey:@"title"];
    [dictionary safeSetValue:self.homeAway forKey:@"homeAway"];
    [dictionary safeSetValue:@{ @"address" : @{ @"displaySingleLine" : self.locationAddress },
                                @"name"    : self.locationName }
                      forKey:@"location"];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [dictionary safeSetValue:[formatter stringFromDate:self.eventDate] forKey:@"eventId"];
    
    return dictionary;
}

@end
