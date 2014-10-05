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

#pragma mark - UIViewController

//
//
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ( !self.dataSource.isAttendanceListAvailable )
    {
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}

#pragma mark - UITableViewDataSource

//
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( !self.dataSource.isAttendanceListAvailable )
    {
        return 1;
    }
    
    return [self.dataSource numberOfSections];
}

//
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( !self.dataSource.isAttendanceListAvailable )
    {
        return 1;
    }
    
    return [self.dataSource numberOfObjectsInSection:section];
}

//
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( !self.dataSource.isAttendanceListAvailable )
    {
        return [self.tableView dequeueReusableCellWithIdentifier:@"ErrorCell"
                                                    forIndexPath:indexPath];
    }
    
    ITCEventAttendanceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonCell"
                                                                                 forIndexPath:indexPath];
    ITCEventRsvp *rsvp = [self.dataSource objectAtIndexPath:indexPath];
    
    cell.userNameLabel.text = rsvp.user.fullName;
    
    if (rsvp.user.hasThumbnailPhoto)
    {
        cell.userImageView.image = rsvp.user.loadedThumbnailPhoto;
    }
    else
    {
        cell.userImageView.image = [self defaultImageThumbnailForUser:rsvp.user];
    }
    
    return cell;
}

//
//
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ( !self.dataSource.isAttendanceListAvailable )
    {
        return nil;
    }
    
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

#pragma mark - Private

//
//
- (UIImage *)defaultImageThumbnailForUser:(ITCUser *)user
{
    static UIImage *femaleImage = nil;
    static UIImage *maleImage   = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        maleImage   = [[ITCAppFactory resourceService] imageWithName:@"defaultUserThumbnail_Male"   extension:@"png"];
        femaleImage = [[ITCAppFactory resourceService] imageWithName:@"defaultUserThumbnail_Female" extension:@"png"];
        
    });
    
    switch (user.gender)
    {
        case ITCUserGenderFemale: return femaleImage;
        case ITCUserGenderMale:
        default:                  return maleImage;
    }
}

@end
