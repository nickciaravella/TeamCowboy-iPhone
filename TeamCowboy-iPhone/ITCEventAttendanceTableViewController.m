//
//  ITCEventAttendanceTableViewController.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCEventAttendanceTableViewController.h"
#import "ITCEventAttendanceTableViewCell.h"
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
    ITCEventAttendanceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonCell"
                                                                                 forIndexPath:indexPath];
    ITCEventRsvp *rsvp = [self.dataSource objectAtIndexPath:indexPath];
    
    cell.userNameLabel.text = rsvp.user.fullName;
    
    if (indexPath.row == 0)
        cell.userMessageLabel.text = nil;
    if (indexPath.row == 1)
        cell.userMessageLabel.text = @"Something short";
    if (indexPath.row == 2)
        cell.userMessageLabel.text = @"Soemthing very afskljsadf;lkjsda;fkjasdfl;jsdaflsdlajflsad;jfkl;sadjf long.";
    
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
