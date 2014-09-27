//
//  ITCEventAttendanceTableViewController.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITCEvent.h"

@interface ITCEventAttendanceTableViewController : UITableViewController

/**
 @brief Creates a new event attendance list controller.
 @param event The event to show the attendance list for.
 @return An instantiated controller.
 */
+ (ITCEventAttendanceTableViewController *)eventAttendanceListForEvent:(ITCEvent *)event;

@end
