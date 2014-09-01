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
        
        [self loadAttendanceListForEachEvent];
        
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

- (id)objectForTag:(NSInteger)tag
{
    return self.events[ tag ];
}

#pragma mark - Private

//
//
- (void)loadAttendanceListForEachEvent
{
    NSArray *events = [self.events copy];
    for (int i = 0; i < [events count]; ++i)
    {
        [self dispatchConcurrentQueueFromUx:^{
            
            NSError *error = nil;
            [events[i] loadAttendanceListBypassingCache:NO withError:&error];
            
            if ( error )
            {
                ITCLogError( error, @"Failed to load attendance list for event: %@", events[i] );
            }
            else
            {
                [self.delegate dataSource:self
             didUpdateObjectsAtIndexPaths:@[ [NSIndexPath indexPathForRow:i inSection:0] ]];
            }
            
        }];
    }
}

@end
