//
//  ITCEventAttendanceTableViewDataSource.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCEventAttendanceTableViewDataSource.h"
#import <UIKit/UIKit.h>

#pragma mark - ITCEventAttendanceTableViewDataSource ()

@interface ITCEventAttendanceTableViewDataSource ()

// 2-dimensional array.
// Attending -> List of rspvs
// Not Attending -> List of rsvps
// The values of the left side are captured in the "statuses" property.
// List of users is an NSArray of ITCEventRsvp objects.
@property (nonatomic, strong) NSMutableArray *rsvps;

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
    source.rsvps = [NSMutableArray new];
    source.statuses = [NSMutableArray new];
    
    [self addUsersForStatus:ITCEventRsvpStatusYes        withStatusText:@"Attending"       forDataSource:source withEvent:event];
    [self addUsersForStatus:ITCEventRsvpStatusMaybe      withStatusText:@"Maybe Attending" forDataSource:source withEvent:event];
    [self addUsersForStatus:ITCEventRsvpStatusNo         withStatusText:@"Not Attending"   forDataSource:source withEvent:event];
    [self addUsersForStatus:ITCEventRsvpStatusAvailable  withStatusText:@"Available"       forDataSource:source withEvent:event];
    [self addUsersForStatus:ITCEventRsvpStatusNoResponse withStatusText:@"No Response"     forDataSource:source withEvent:event];
    
    [source loadUsersThumbnailPhotos];
    
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
        [dataSource.rsvps addObject:users];
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
    return [self.rsvps[section] count];
}

//
//
- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return self.rsvps[indexPath.section][indexPath.row];
}

//
//
- (id)objectForSection:(NSUInteger)section
{
    return self.statuses[section];
}

#pragma mark - Private

//
//
- (void)loadUsersThumbnailPhotos
{
    for (int i = 0; i < [self.rsvps count]; ++i)
    {
        NSArray *listOfRsvps = self.rsvps[i];

        for (int j = 0; j < [listOfRsvps count]; ++j)
        {
            [self dispatchConcurrentQueueFromUx:^{

                ITCEventRsvp *rsvp = listOfRsvps[j];
                if ( rsvp.user.hasThumbnailPhoto && !rsvp.user.loadedThumbnailPhoto )
                {
                    NSError *loadError = nil;
                    [rsvp.user loadThumbnailPhotoWithError:&loadError];
                    ITCLogAndReturnOnError( loadError, @"Failed to load thumbnail photo for user: %@", rsvp.user );
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                    [self.delegate dataSource:self didUpdateObjectsAtIndexPaths:@[ indexPath ]];
                }
                
            }];
        }
    }
}

@end
