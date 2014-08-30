//
//  ITCEventsTableViewController.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCEventsTableViewController.h"
#import "ITCEvent.h"
#import "ITCEventTableViewCell.h"

#pragma mark - ITCEventsTableViewController ()

@interface ITCEventsTableViewController ()

@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSError *loadingError;

@end

#pragma mark - ITCEventsTableViewController (implementation)

@implementation ITCEventsTableViewController

#pragma mark - ITCAppTabBarItem

//
//
- (void)startLoadingDataForUser:(ITCUser *)user
{
    self.events = nil;
    self.loadingError = nil;
    [self.tableView reloadData];
    
    [self dispatchConcurrentQueueFromUx:^{
        
        NSError *loadError = nil;
        self.events = [user loadTeamEventsBypassingCache:NO withError:&loadError];
        self.loadingError = loadError;
        
        [self dispatchMainQueue:^{
            [self.tableView reloadData];
        }];
        
    }];
}

#pragma mark - UITableViewDelegate

//
//
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ITCEventTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
    
    if ( self.loadingError )
    {
        // TODO: handle showing error view
        return cell;
    }
    
    // TODO: Add default text if any properties are missing.
    
    ITCEvent *event = self.events[ indexPath.row ];
    cell.teamNameLabel.text     = event.teamName;
    cell.opponentNameLabel.text = event.opponentName;
    cell.homeAwayLabel.text     = [self displayStringFromHomeAway:event.homeAway];
    
    [cell.locationButton setTitle:event.locationName forState:UIControlStateNormal];
    cell.locationButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    cell.locationButton.layer.borderWidth = 1;
    cell.locationButton.tag = indexPath.row;
    [cell.locationButton addTarget:self action:@selector(onLocationClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MMMM d";
    cell.dateLabel.text = [formatter stringFromDate:event.eventDate];
    
    formatter.dateFormat = @"h:mm a";
    cell.timeLabel.text = [formatter stringFromDate:event.eventDate];
    
    return cell;
}

#pragma mark - UITableViewDataSource

//
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//
//
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return ( self.loadingError ) ? 1 : [self.events count];
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
- (void)onLocationClicked:(UIButton *)sender
{
    ITCEvent *event = self.events[ sender.tag ];
    [self openUrlForMapWithLocation:event.locationAddress];
}

@end
