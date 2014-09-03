//
//  ITCEventsTableViewDataSource.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCEvent.h"
#import "ITCUser.h"

@class ITCEventsTableViewDataSource;

/**
 @brief Delegate for the data source to send updates object changes.
 */
@protocol ITCEventsTableViewDataSourceDelegate <NSObject>

/**
 @brief Notifies the delegate that the data source completed a load of all the objects.
 @param source The data source.
 */
- (void)dataSourceDidCompleteLoadingObjects:(ITCEventsTableViewDataSource *)source;

/**
 @brief Notifies the delegate that the data source updated some objects.
 @param source     The data source.
 @param indexPaths A list of index paths of the objects that were updated.
 */
- (void)dataSource:(ITCEventsTableViewDataSource *)source didUpdateObjectsAtIndexPaths:(NSArray *)indexPaths;

@end

/**
 @brief A data source for the events table view.
 */
@interface ITCEventsTableViewDataSource : NSObject

/**
 @brief If an error occurred during loading, it is persisted here.
 */
@property (nonatomic, readonly) NSError *loadingError;

/**
 @brief Delegate to notify of changes.
 */
@property (nonatomic, weak) id<ITCEventsTableViewDataSourceDelegate> delegate;

/**
 @brief Reloads all of the objects for a given user.
 @param user        The user that data should be loaded for.
 @param bypassCache YES if the cache should be bypassed.
 */
- (void)reloadObjectsForUser:(ITCUser *)user bypassingCache:(BOOL)bypassCache;

/**
 @brief Gets an object for an index path.
 @param indexPath The index path
 @return The object.
 */
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

/**
 @brief Returns the number of sections of data.
 */
- (NSInteger)numberOfSections;

/**
 @brief Returns the number objects in a particular section.
 @param section The section.
 @return The number of objects.
 */
- (NSInteger)numberOfObjectsInSection:(NSInteger)section;

/** 
 @brief Returns a tag (unique identifier) for an object in the collection. This object can then be retrieved using -[objectForTag]
 @param indexPath The index path of the object
 @return The tag.
 */
- (NSInteger)tagForObjectAtIndexPath:(NSIndexPath *)indexPath;

/**
 @brief Returns an object for a given tag. The tag should have been given based on -[tagForObjectAtIndexPath:]
 @param tag The object's tag
 @return The object.
 */
- (id)objectForTag:(NSInteger)tag;

/**
 @brief Begins the workflow to send an RSVP for a event. It will call the delegate to report errors or updates based on the RSVP action.
 @param tag    The tag of the object to initiate the action on.
 @param status The RSVP status to send.
 */
- (void)rsvpForEventWithTag:(NSInteger)tag
                 withStatus:(ITCEventRsvpStatus)status;

@end
