//
//  ITCTableViewDataSourceDelegate.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITCTableViewDataSource.h"

@class ITCTableViewDataSource;

@protocol ITCTableViewDataSourceDelegate <NSObject>

/**
 @brief Notifies the delegate that the data source completed a load of all the objects.
 @param source The data source.
 */
- (void)dataSourceDidCompleteLoadingObjects:(ITCTableViewDataSource *)source;

/**
 @brief Notifies the delegate that the data source updated some objects.
 @param source     The data source.
 @param indexPaths A list of index paths of the objects that were updated.
 */
- (void)dataSource:(ITCTableViewDataSource *)source didUpdateObjectsAtIndexPaths:(NSArray *)indexPaths;

@end
