//
//  ITCTableViewDataSource.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITCTableViewDataSourceDelegate.h"

@interface ITCTableViewDataSource : NSObject

/**
 @brief Delegate to notify of changes.
 */
@property (nonatomic, weak) id<ITCTableViewDataSourceDelegate> delegate;

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

@end
