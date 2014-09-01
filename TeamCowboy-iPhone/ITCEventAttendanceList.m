//
//  ITCEventAttendanceList.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCEventAttendanceList.h"

@implementation ITCEventAttendanceList

#pragma mark - ITCSerializableObject

//
//
+ (NSDictionary *)propertyToKeyPathMapping
{
    return @{
             @"rsvps" : @"users"
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

#pragma mark - ITCEventAttendanceList

//
//
- (NSUInteger)numberOfResponsesMatchingStatus:(ITCEventRsvpStatus)status
{
    return [[self.rsvps filteredArrayUsingBlock:^BOOL(ITCEventRsvp *element) {
        return ( element.status == status );
    }] count];
}

@end
