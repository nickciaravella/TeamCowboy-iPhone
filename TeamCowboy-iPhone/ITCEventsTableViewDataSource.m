//
//  ITCEventsTableViewDataSource.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCEventsTableViewDataSource.h"
#import "ITCEvent.h"

@interface ITCEventsTableViewDataSource ()

@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSError *loadingError;

@end

@implementation ITCEventsTableViewDataSource

//
//
- (void)reloadObjectsForUser:(ITCUser *)user bypassingCache:(BOOL)bypassCache
{
    [self dispatchConcurrentQueueFromUx:^{
        
        NSError *loadError = nil;
        self.events = [user loadTeamEventsBypassingCache:bypassCache withError:&loadError];
        self.loadingError = loadError;
        [self.delegate dataSourceDidCompleteLoadingObjects:self];
        
        [self loadAttendanceListForEachEventBypassingCache:bypassCache];
        
    }];
}

//
//
- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return self.events[ indexPath.row ];
}

//
//
- (NSInteger)numberOfSections
{
    return 1;
}

//
- (NSInteger)numberOfObjectsInSection:(NSInteger)section
{
    return [self.events count];
}

//
//
- (NSInteger)tagForObjectAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row;
}

//
//
- (id)objectForTag:(NSInteger)tag
{
    return self.events[ tag ];
}

//
//
- (void)rsvpForEventWithTag:(NSInteger)tag
                 withStatus:(ITCEventRsvpStatus)status
{
    [self dispatchConcurrentQueueFromUx:^{
        
        ITCEvent *event = [self objectForTag:tag];
        NSError *rsvpError = [event rsvpWithStatus:status
                                   additionalMales:0
                                 additionalFemales:0
                                          comments:nil];
        // TODO: Call delegate with error.
        ITCLogAndReturnOnError(rsvpError, @"Failed to send RSVP for event. RSVP: %@, Event: %@", NSStringFromRsvpStatus(status), event);
        
        NSError *reloadEventError = [event loadAttendanceListBypassingCache:YES];
        ITCLogAndReturnOnError(reloadEventError, @"Failed to reload event attendance list after RSVP. Event: %@", event);
        
        [self.delegate dataSource:self
     didUpdateObjectsAtIndexPaths:@[ [self indexPathForEventAtIndex:tag] ]];
        
    }];
}

#pragma mark - Private

//
//
- (void)loadAttendanceListForEachEventBypassingCache:(BOOL)bypassCache
{
    NSArray *events = [self.events copy];
    for (int i = 0; i < [events count]; ++i)
    {
        [self dispatchConcurrentQueueFromUx:^{
            
            NSError *error = [events[i] loadAttendanceListBypassingCache:bypassCache];
            if ( error )
            {
                ITCLogError( error, @"Failed to load attendance list for event: %@", events[i] );
            }
            else
            {
                [self.delegate dataSource:self
             didUpdateObjectsAtIndexPaths:@[ [self indexPathForEventAtIndex:i] ]];
            }
            
        }];
    }
}

//
//
- (NSIndexPath *)indexPathForEventAtIndex:(NSUInteger)index
{
    return [NSIndexPath indexPathForRow:index inSection:0];
}

@end
