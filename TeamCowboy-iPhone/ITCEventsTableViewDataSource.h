//
//  ITCEventsTableViewDataSource.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCEvent.h"
#import "ITCTableViewDataSource.h"
#import "ITCUser.h"

/**
 @brief A data source for the events table view.
 */
@interface ITCEventsTableViewDataSource : ITCTableViewDataSource

/**
 @brief If an error occurred during loading, it is persisted here.
 */
@property (nonatomic, readonly) NSError *loadingError;


/**
 @brief Reloads all of the objects for a given user.
 @param user        The user that data should be loaded for.
 @param bypassCache YES if the cache should be bypassed.
 */
- (void)reloadObjectsForUser:(ITCUser *)user bypassingCache:(BOOL)bypassCache;

/**
 @brief Begins the workflow to send an RSVP for a event. It will call the delegate to report errors or updates based on the RSVP action.
 @param tag    The tag of the object to initiate the action on.
 @param status The RSVP status to send.
 */
- (void)rsvpForEventWithTag:(NSInteger)tag
                 withStatus:(ITCEventRsvpStatus)status;

@end
