//
//  ITCEventAttendanceTableViewController.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCEventAttendanceTableViewController.h"
#import "ITCEventAttendanceTableViewDataSource.h"

#pragma mark - ITCEventAttendanceTableViewController ()

@interface ITCEventAttendanceTableViewController () <ITCTableViewDataSourceDelegate>

@property (nonatomic, strong) ITCEvent *event;
@property (nonatomic, strong) ITCEventAttendanceTableViewDataSource *dataSource;

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
    controller.dataSource = [ITCEventAttendanceTableViewDataSource dataSourceWithEvent:event delegate:controller];
    
    return controller;
}

#pragma mark - UITableViewDataSource

//
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource numberOfSections];
}

//
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource numberOfObjectsInSection:section];
}

//
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonCell" forIndexPath:indexPath];
    ITCEventRsvp *rsvp = [self.dataSource objectAtIndexPath:indexPath];
    
    cell.textLabel.text = rsvp.user.fullName;
    
    return cell;
}

//
//
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.dataSource objectForSection:section];
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
        [self.tableView reloadData];
    }];
}

@end
