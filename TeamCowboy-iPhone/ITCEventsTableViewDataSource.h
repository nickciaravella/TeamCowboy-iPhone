//
//  ITCEventsTableViewDataSource.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCEvent.h"
#import "ITCTableViewDataSource.h"
#import "ITCUser.h"

@class ITCEventsTableViewDataSource;

/**
 @brief Extension of the ITCTableViewDataSourceDelegate to handle events table view data source specific callbacks.
 */
@protocol ITCEventsTableViewDataSourceDelegate <ITCTableViewDataSourceDelegate>

/**
 @brief Notifies the delegate that the data source failed to RSVP for an event.
 @param source The data source.
 @param event  The tag of the event that was not RSVP'ed for.
 @param status The status that was attempted.
 @param error  The error that was hit when RSVPing.
 */
- (void)dataSource:(ITCEventsTableViewDataSource *)source
didFailToRsvpForEventWithTag:(NSInteger)eventTag
         forStatus:(ITCEventRsvpStatus)status
         withError:(NSError *)error;

@end

/**
 @brief A data source for the events table view.
 */
@interface ITCEventsTableViewDataSource : ITCTableViewDataSource

/**
 @brief Delegate to notify of changes.
 */
@property (nonatomic, weak) id<ITCEventsTableViewDataSourceDelegate> delegate;

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
