//
//  ITCEventAttendanceTableViewController.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCEventAttendanceTableViewController.h"

#pragma mark - ITCEventAttendanceTableViewController ()

@interface ITCEventAttendanceTableViewController ()

@property (nonatomic, strong) ITCEvent *event;

@end

#pragma mark - ITCEventAttendanceTableViewController (implementation)

@implementation ITCEventAttendanceTableViewController

//
//
+ (ITCEventAttendanceTableViewController *)eventAttendanceListForEvent:(ITCEvent *)event
{
    ITCEventAttendanceTableViewController *controller = [[ITCAppFactory resourceService] controllerFromStoryboard:@"Events"
                                                                                                   withIdentifier:@"AttendanceList"];
    controller.event = event;
    
    return controller;
}

@end
