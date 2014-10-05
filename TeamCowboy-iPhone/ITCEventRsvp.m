//
//  ITCEventRsvp.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCEventRsvp.h"

#pragma mark - NSStringFromRsvpStatus

//
//
NSString *NSStringFromRsvpStatus(ITCEventRsvpStatus status)
{
    switch (status)
    {
        case ITCEventRsvpStatusAvailable:  return @"Available";
        case ITCEventRsvpStatusMaybe:      return @"Maybe";
        case ITCEventRsvpStatusNo:         return @"No";
        case ITCEventRsvpStatusNoResponse: return @"No Response";
        case ITCEventRsvpStatusYes:        return @"Yes";
        case ITCEventRsvpStatusUnknown:    return @"Unknown";
        default:                           return @"*** Invalid Status ***";
    }
}

#pragma mark - ITCEventRsvp ()

@interface ITCEventRsvp ()

@property (nonatomic, readonly) NSString *serverStatus;

@end

#pragma mark - ITCEventRsvp (implementation)

@implementation ITCEventRsvp

#pragma mark - ITCSerializableObject

//
//
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (!(self = [super initWithDictionary:dictionary])) { return nil; }

    _status       = [self statusFromServerStatus:_serverStatus];
    
    return self;
}

//
//
+ (NSDictionary *)propertyToKeyPathMapping
{
    return @{
             @"user"         : @"user",
             @"serverStatus" : @"rsvpInfo.status",
             @"comments"     : @"rsvpInfo.comments"
             };
}

//
//
+ (NSDictionary *)embeddedObjectPropertyToClassMapping
{
    return @{
             @"user" : NSStringFromClass([ITCUser class])
             };
}

#pragma mark - Private

//
//
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
