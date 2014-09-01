//
//  ITCEventsTableViewController.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCEventsTableViewController.h"
#import "ITCEvent.h"
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
    
    if ( self.dataSource.loadingError )
    {
        // TODO: handle showing error view
        return cell;
    }
    
    // TODO: Add default text if any properties are missing.
    ITCEvent *event = [self.dataSource objectAtIndexPath:indexPath];
    cell.locationButton.tag = [self.dataSource tagForObjectAtIndexPath:indexPath];
    
    cell.teamNameLabel.text     = event.teamName;
    cell.opponentNameLabel.text = event.opponentName;
    cell.homeAwayLabel.text     = [self displayStringFromHomeAway:event.homeAway];
    
    [cell.locationButton setTitle:event.locationName forState:UIControlStateNormal];
    cell.locationButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    cell.locationButton.layer.borderWidth = 1;
    [cell.locationButton addTarget:self action:@selector(onLocationClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // Date and time
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MMMM d";
    cell.dateLabel.text = [formatter stringFromDate:event.eventDate];
    
    formatter.dateFormat = @"h:mm a";
    cell.timeLabel.text = [formatter stringFromDate:event.eventDate];
    
    // RSVPs
    NSUInteger yesResponses   = [event.attendanceList numberOfResponsesMatchingStatus:ITCEventRsvpStatusYes];
    cell.yesRSVPLabel.text    = [NSString stringWithFormat:@"%lu", yesResponses];
    
    NSUInteger noResponses    = [event.attendanceList numberOfResponsesMatchingStatus:ITCEventRsvpStatusNo];
    cell.noRSVPLabel.text     = [NSString stringWithFormat:@"%lu", noResponses];
    
    NSUInteger maybeResponses = [event.attendanceList numberOfResponsesMatchingStatus:ITCEventRsvpStatusMaybe];
    cell.maybeRSVPLabel.text  = [NSString stringWithFormat:@"%lu", maybeResponses];
    
    cell.currentUserRSVPStatusView.backgroundColor = [self colorOfCurrentUserRsvpInAttendanceList:event.attendanceList];
    
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
- (void)onLocationClicked:(UIButton *)sender
{
    ITCEvent *event = [self.dataSource objectForTag:sender.tag];
    [self openUrlForMapWithLocation:event.locationAddress];
}

@end
