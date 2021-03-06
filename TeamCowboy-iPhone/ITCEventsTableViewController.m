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

@interface ITCEventsTableViewController () <ITCEventsTableViewDataSourceDelegate>

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

#pragma mark - UIViewController

//
//
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(onRefreshControlActivated)
                  forControlEvents:UIControlEventValueChanged];
    
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
    if ( self.dataSource.loadingError )
    {
        return [self.tableView dequeueReusableCellWithIdentifier:@"errorCell"
                                                    forIndexPath:indexPath];
    }
    
    ITCEventTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"eventCell"
                                                                       forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    [self setupRsvpDataForCell:cell withEvent:event];
    
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
- (void)dataSource:(ITCTableViewDataSource *)source didUpdateObjectsAtIndexPaths:(NSArray *)indexPaths
{
    [self dispatchMainQueueIfNeeded:^{
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }];
}

//
//
- (void)dataSourceDidCompleteLoadingObjects:(ITCTableViewDataSource *)source
{
    [self dispatchMainQueueIfNeeded:^{
        
        if ( self.dataSource.loadingError )
        {
            self.tableView.rowHeight = UITableViewAutomaticDimension;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        else
        {
            self.tableView.rowHeight = 225;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
        
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        
    }];
}

//
//
- (void)dataSource:(ITCEventsTableViewDataSource *)source
didFailToRsvpForEventWithTag:(NSInteger)eventTag
         forStatus:(ITCEventRsvpStatus)status
         withError:(NSError *)error
{
    ITCEvent *event = [self.dataSource objectForTag:eventTag];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"EEEE, MMM. d";
    NSString *errorMessage = [NSString stringWithFormat:@"There was a problem submitting your RSVP for the event with the %@ on %@.",
                              event.opponentName, [formatter stringFromDate:event.eventDate]];
    
    ITCBasicButtonInfo *retryButton = [ITCBasicButtonInfo buttonInfoWithTitle:@"Retry" action:^{
        [self.dataSource rsvpForEventWithTag:eventTag withStatus:status];
    }];
    
    [[ITCAppFactory alertingService] showAlertWithTitle:@"Something Went Wrong"
                                                message:errorMessage
                                           cancelButton:[ITCBasicButtonInfo buttonInfoWithTitle:@"Ok" action:nil]
                                           otherButtons:@[ retryButton ]];
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
    
    if ( [ITCAppFactory isVNextApp] )
    {
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
    else
    {
        ITCBasicButtonInfo *maybeAttendingButton = [ITCBasicButtonInfo buttonInfoWithTitle:@"Maybe Attending" action:^{
            [self.dataSource rsvpForEventWithTag:sender.tag withStatus:ITCEventRsvpStatusMaybe];
        }];
        
        [[ITCAppFactory alertingService] showAlertWithTitle:@"RSVP"
                                                    message:nil
                                               cancelButton:[ITCBasicButtonInfo buttonInfoWithTitle:@"Cancel" action:nil]
                                               otherButtons:@[
                                                              attendingButton,
                                                              maybeAttendingButton,
                                                              notAttendingButton
                                                              ]];
    }
}

//
//
- (void)onRefreshControlActivated
{
    [self.dataSource reloadObjectsForUser:self.currentUser bypassingCache:YES];
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

//
//
- (void)setupRsvpDataForCell:(ITCEventTableViewCell *)cell
                   withEvent:(ITCEvent *)event
{
    if ( !event.isAttendanceListLoaded )
    {
        cell.yesRSVPLabel.text    = nil;
        cell.noRSVPLabel.text     = nil;
        cell.maybeRSVPLabel.text  = nil;
        cell.currentUserRSVPStatusView.backgroundColor = [UIColor clearColor];
    }
    else if ( event.isAttendanceListLoaded && event.attendanceList == nil )
    {
        cell.yesRSVPLabel.text    = @"?";
        cell.noRSVPLabel.text     = @"?";
        cell.maybeRSVPLabel.text  = @"?";
        cell.currentUserRSVPStatusView.backgroundColor = [UIColor clearColor];
    }
    else
    {
        NSUInteger yesResponses   = [event.attendanceList numberOfResponsesMatchingStatus:ITCEventRsvpStatusYes];
        cell.yesRSVPLabel.text    = [NSString stringWithFormat:@"%lu", yesResponses];
        
        NSUInteger noResponses    = [event.attendanceList numberOfResponsesMatchingStatus:ITCEventRsvpStatusNo];
        cell.noRSVPLabel.text     = [NSString stringWithFormat:@"%lu", noResponses];
        
        NSUInteger maybeResponses = [event.attendanceList numberOfResponsesMatchingStatus:ITCEventRsvpStatusMaybe];
        cell.maybeRSVPLabel.text  = [NSString stringWithFormat:@"%lu", maybeResponses];
        
        cell.currentUserRSVPStatusView.backgroundColor = [self colorOfCurrentUserRsvpInAttendanceList:event.attendanceList];
    }
    
    [cell.rsvpButton addTarget:self action:@selector(onRsvpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

@end
