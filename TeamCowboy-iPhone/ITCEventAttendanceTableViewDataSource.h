//
//  ITCEventAttendanceTableViewDataSource.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCEvent.h"
#import "ITCTableViewDataSource.h"

@interface ITCEventAttendanceTableViewDataSource : ITCTableViewDataSource

/**
 @brief Creates a new data source with the given event.
 @param event The event
 @return The new data source
 */
+ (ITCEventAttendanceTableViewDataSource *)dataSourceWithEvent:(ITCEvent *)event
                                                      delegate:(id<ITCTableViewDataSourceDelegate>)delegate;

@end
