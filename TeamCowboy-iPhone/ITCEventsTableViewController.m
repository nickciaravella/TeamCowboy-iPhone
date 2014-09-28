//
//  ITCEventsTableViewController.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCEventsTableViewController.h"
#import "ITCEvent.h"
#import "ITCEventAttendanceTableViewController.h"
#import "ITCEventTableViewCell.h"
#import "ITCEventsTableViewDataSource.h"
#import "UIColor+AppColors.h"

#pragma mark - ITCEventsTableViewController ()

@interface ITCEventsTableViewController () <ITCTableViewDataSourceDelegate>

@property (nonatomic, strong) ITCEventsTableViewDataSource *dataSource;
@property (nonatomic, strong) ITCUser *currentUser;

@end

#pragma mark - ITCEventsTableViewController (implementation)

@implementation ITCEventsTableViewController

#pragma mark - NSCoding

//
//
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder])) { return nil; }
    
    _dataSource = [ITCEventsTableViewDataSource new];
    _dataSource.delegate = self;
    
    return self;
}

#pragma mark - ITCAppTabBarItem

//
//
- (void)startLoadingDataForUser:(ITCUser *)user
{
    self.currentUser = user;
    [self.tableView reloadData];
    [self.dataSource reloadObjectsForUser:user bypassingCache:NO];
}

#pragma mark - UITableViewDelegate

//
//
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ITCEventTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ( self.dataSource.loadingError )
    {
        // TODO: handle showing error view
        return cell;
    }
    
    // TODO: Add default text if any properties are missing.
    ITCEvent *event         = [self.dataSource objectAtIndexPath:indexPath];
    cell.locationButton.tag = [self.dataSource tagForObjectAtIndexPath:indexPath];
    cell.rsvpButton.tag     = [self.dataSource tagForObjectAtIndexPath:indexPath];
    
    // Team and opponent
    cell.teamNameLabel.text     = event.teamName;
    cell.opponentNameLabel.text = event.opponentName;
    cell.homeAwayLabel.text     = [self displayStringFromHomeAway:event.homeAway];
    
    // Location
    NSString *locationButtonText = ( event.locationAddress.length > 0 ) ? event.locationName : @"Location not available";
    [cell.locationButton setTitle:locationButtonText forState:UIControlStateNormal];
    [cell.locationButton addTarget:self action:@selector(onLocationClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.locationButton.enabled = ( event.locationAddress.length > 0 );
    
    // Date and time
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"EEEE, MMM. d";
    cell.dateLabel.text = [formatter stringFromDate:event.eventDate];
    
    formatter.dateFormat = @"h:mm a";
    cell.timeLabel.text = ( event.isTimeTBD ) ? nil : [formatter stringFromDate:event.eventDate];
    
    // RSVPs
    NSUInteger yesResponses   = [event.attendanceList numberOfResponsesMatchingStatus:ITCEventRsvpStatusYes];
    cell.yesRSVPLabel.text    = [NSString stringWithFormat:@"%lu", yesResponses];
    
    NSUInteger noResponses    = [event.attendanceList numberOfResponsesMatchingStatus:ITCEventRsvpStatusNo];
    cell.noRSVPLabel.text     = [NSString stringWithFormat:@"%lu", noResponses];
    
    NSUInteger maybeResponses = [event.attendanceList numberOfResponsesMatchingStatus:ITCEventRsvpStatusMaybe];
    cell.maybeRSVPLabel.text  = [NSString stringWithFormat:@"%lu", maybeResponses];
    
    cell.currentUserRSVPStatusView.backgroundColor = [self colorOfCurrentUserRsvpInAttendanceList:event.attendanceList];
    [cell.rsvpButton addTarget:self action:@selector(onRsvpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UITableViewDataSource

//
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ( self.dataSource.loadingError ) ? 1 : [self.dataSource numberOfSections];
}

//
//
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return ( self.dataSource.loadingError ) ? 1 : [self.dataSource numberOfObjectsInSection:section];
}

#pragma mark - ITCEventsTableViewDataSourceDelegate

//
//
- (void)dataSource:(ITCEventsTableViewDataSource *)source didUpdateObjectsAtIndexPaths:(NSArray *)indexPaths
{
    [self dispatchMainQueueIfNeeded:^{
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }];
}

//
//
- (void)dataSourceDidCompleteLoadingObjects:(ITCEventsTableViewDataSource *)source
{
    [self dispatchMainQueueIfNeeded:^{
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate

//
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ITCEvent *event = [self.dataSource objectAtIndexPath:indexPath];
    ITCEventAttendanceTableViewController *attendanceListController = [ITCEventAttendanceTableViewController eventAttendanceListForEvent:event];
    
    [self.navigationController pushViewController:attendanceListController animated:YES];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Button actions

//
//
- (void)onLocationClicked:(UIButton *)sender
{
    ITCEvent *event = [self.dataSource objectForTag:sender.tag];
    [self openUrlForMapWithLocation:event.locationAddress];
}

//
//
- (void)onRsvpButtonClicked:(UIButton *)sender
{
    ITCBasicButtonInfo *attendingButton = [ITCBasicButtonInfo buttonInfoWithTitle:@"Attending" action:^{
        [self.dataSource rsvpForEventWithTag:sender.tag withStatus:ITCEventRsvpStatusYes];
    }];
    ITCBasicButtonInfo *notAttendingButton = [ITCBasicButtonInfo buttonInfoWithTitle:@"Not Attending" action:^{
        [self.dataSource rsvpForEventWithTag:sender.tag withStatus:ITCEventRsvpStatusNo];
    }];
    ITCBasicButtonInfo *moreOptionsButton = [ITCBasicButtonInfo buttonInfoWithTitle:@"More Options" action:^{
        ITCLog(@"More Options button clicked.");
    }];
    
    [[ITCAppFactory alertingService] showAlertWithTitle:@"RSVP"
                                                message:nil
                                           cancelButton:[ITCBasicButtonInfo buttonInfoWithTitle:@"Cancel" action:nil]
                                           otherButtons:@[
                                                          attendingButton,
                                                          notAttendingButton,
                                                          moreOptionsButton
                                                          ]];
}

#pragma mark - Private

//
//
- (NSString *)displayStringFromHomeAway:(NSString *)homeAway
{
    if ( [homeAway isEqualToString:@"Away"] )
    {
        return @"at";
    }
    if ( [homeAway isEqualToString:@"Home"] )
    {
        return @"vs.";
    }
    return nil;
}

//
//
- (UIColor *)colorOfCurrentUserRsvpInAttendanceList:(ITCEventAttendanceList *)attendance
{
    ITCEventRsvp *rsvp = [attendance.rsvps firstObjectUsingBlock:^BOOL(ITCEventRsvp *element) {
        return ( element.user.userId == self.currentUser.userId );
    }];
    
    switch (rsvp.status)
    {
        case ITCEventRsvpStatusYes:   return [UIColor attendingColor];
        case ITCEventRsvpStatusMaybe: return [UIColor maybeAttendingColor];
        case ITCEventRsvpStatusNo:    return [UIColor notAttendingColor];
        default:                      return [UIColor clearColor];
    }
}

@end
