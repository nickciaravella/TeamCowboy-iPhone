//
//  ITCEventRsvp.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCEventRsvp.h"

@interface ITCEventRsvp ()

@property (nonatomic, readonly) NSString *serverStatus;

@end

@implementation ITCEventRsvp

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (!(self = [super initWithDictionary:dictionary])) { return nil; }
    
    _userId       = dictionary[ @"userId" ];
    _serverStatus = dictionary[ @"rsvpDetails" ][ @"status" ];
    _status       = [self statusFromServerStatus:_serverStatus];
    
    return self;
}

- (NSDictionary *)dictionaryFormat
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    [dictionary safeSetValue:self.userId forKey:@"userId"];
    [dictionary safeSetValue:@{ @"status" : self.serverStatus } forKey:@"rsvpDetails"];
    
    return dictionary;
}

- (ITCEventRsvpStatus)statusFromServerStatus:(NSString *)serverStatus
{
    if      ([serverStatus isEqualToString:@"yes"])        return ITCEventRsvpStatusYes;
    else if ([serverStatus isEqualToString:@"no"])         return ITCEventRsvpStatusNo;
    else if ([serverStatus isEqualToString:@"available"])  return ITCEventRsvpStatusAvailable;
    else if ([serverStatus isEqualToString:@"maybe"])      return ITCEventRsvpStatusMaybe;
    else if ([serverStatus isEqualToString:@"noresponse"]) return ITCEventRsvpStatusNoResponse;
    return ITCEventRsvpStatusUnknown;
}

@end
