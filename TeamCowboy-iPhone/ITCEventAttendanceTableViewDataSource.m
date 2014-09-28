//
//  ITCEventAttendanceTableViewDataSource.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCEventAttendanceTableViewDataSource.h"

#pragma mark - ITCEventAttendanceTableViewDataSource ()

@interface ITCEventAttendanceTableViewDataSource ()

// 2-dimensional array.
// Attending -> List of users
// Not Attending -> List of users
// The values of the left side are captured in the "statuses" property.
// List of users is an NSArray of ITCUser objects.
@property (nonatomic, strong) NSMutableArray *users;

// The statuses of users. This omits any status with no user.
// The values in the array are NSString objects.
@property (nonatomic, strong) NSMutableArray *statuses;

@end

#pragma mark - ITCEventAttendanceTableViewDataSource (implementation)

@implementation ITCEventAttendanceTableViewDataSource

#pragma mark - Creation and setup

//
//
+ (ITCEventAttendanceTableViewDataSource *)dataSourceWithEvent:(ITCEvent *)event
                                                      delegate:(id<ITCTableViewDataSourceDelegate>)delegate
{
    ITCEventAttendanceTableViewDataSource *source = [ITCEventAttendanceTableViewDataSource new];

    source.delegate = delegate;    
    source.users = [NSMutableArray new];
    source.statuses = [NSMutableArray new];
    
    [self addUsersForStatus:ITCEventRsvpStatusYes        withStatusText:@"Attending"       forDataSource:source withEvent:event];
    [self addUsersForStatus:ITCEventRsvpStatusMaybe      withStatusText:@"Maybe Attending" forDataSource:source withEvent:event];
    [self addUsersForStatus:ITCEventRsvpStatusNo         withStatusText:@"Not Attending"   forDataSource:source withEvent:event];
    [self addUsersForStatus:ITCEventRsvpStatusAvailable  withStatusText:@"Available"       forDataSource:source withEvent:event];
    [self addUsersForStatus:ITCEventRsvpStatusNoResponse withStatusText:@"No Response"     forDataSource:source withEvent:event];
    
    return source;
}

//
//
+ (void)addUsersForStatus:(ITCEventRsvpStatus)status
           withStatusText:(NSString *)statusText
            forDataSource:(ITCEventAttendanceTableViewDataSource *)dataSource
                withEvent:(ITCEvent *)event
{
    NSArray *users = [event.attendanceList rsvpsMatchingStatus:status];
    if ( [users count] > 0 )
    {
        [dataSource.statuses addObject:statusText];
        [dataSource.users addObject:users];
    }
}

#pragma mark - ITCTableViewDataSource

//
//
- (NSInteger)numberOfSections
{
    return [self.statuses count];
}

//
//
- (NSInteger)numberOfObjectsInSection:(NSInteger)section
{
    return [self.users[section] count];
}

//
//
- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return self.users[indexPath.section][indexPath.row];
}

//
//
- (id)objectForSection:(NSUInteger)section
{
    return self.statuses[section];
}

@end
