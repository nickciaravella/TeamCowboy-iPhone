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

//
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

//
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0: return [self.event.attendanceList numberOfResponsesMatchingStatus:ITCEventRsvpStatusYes];
        case 1: return [self.event.attendanceList numberOfResponsesMatchingStatus:ITCEventRsvpStatusMaybe];
        case 2: return [self.event.attendanceList numberOfResponsesMatchingStatus:ITCEventRsvpStatusNo];
        case 3:
        default:
            return [self.event.attendanceList numberOfResponsesMatchingStatus:ITCEventRsvpStatusNoResponse];
    }
}

//
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonCell" forIndexPath:indexPath];
    
    NSArray *listOfUsers = nil;
    switch (indexPath.section)
    {
        case 0: listOfUsers = [self.event.attendanceList rsvpsMatchingStatus:ITCEventRsvpStatusYes]; break;
        case 1: listOfUsers = [self.event.attendanceList rsvpsMatchingStatus:ITCEventRsvpStatusMaybe]; break;
        case 2: listOfUsers = [self.event.attendanceList rsvpsMatchingStatus:ITCEventRsvpStatusNo]; break;
        case 3:
        default:
            listOfUsers = [self.event.attendanceList rsvpsMatchingStatus:ITCEventRsvpStatusNoResponse]; break;
    }
    
    ITCEventRsvp *rsvp = listOfUsers[indexPath.row];
    cell.textLabel.text = rsvp.user.fullName;
    
    return cell;
}

//
//
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0: return @"Attending";
        case 1: return @"Maybe Attending";
        case 2: return @"Not Attending";
        case 3:
        default:
            return @"No Response";
    }
}

@end
