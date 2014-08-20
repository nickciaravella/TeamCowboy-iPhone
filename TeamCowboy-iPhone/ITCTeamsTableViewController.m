//
//  ITCTeamsTableViewController.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCTeamsTableViewController.h"
#import "ITCTeam.h"
#import "ITCTeamTableViewCell.h"

#pragma mark - ITCTeamsTableViewController ()

@interface ITCTeamsTableViewController ()

@property (nonatomic, strong) NSArray *teams;
@property (nonatomic, strong) NSError *loadingError;

@end

#pragma mark - ITCTeamsTableViewController (implementation)

@implementation ITCTeamsTableViewController

#pragma mark - ITCAppTabBarItem

//
//
- (void)startLoadingDataForUser:(ITCUser *)user
{
    self.teams = nil;
    self.loadingError = nil;
    [self.tableView reloadData];
    
    [self dispatchConcurrentQueueFromUx:^{
       
        NSError *loadError = nil;
        self.teams = [user loadTeamsBypassingCache:NO withError:&loadError];
        self.loadingError = loadError;
        
        [self loadThumbnailPhotos];
        
        [self dispatchMainQueue:^{
            [self.tableView reloadData];
        }];
        
    }];
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
    return ( self.loadingError ) ? 1 : [self.teams count];
}

#pragma mark - UITableViewDelegate

//
//
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ITCTeamTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"teamCell" forIndexPath:indexPath];
    
    if ( self.loadingError )
    {
        // TODO: handle showing error view
        return cell;
    }
    
    ITCTeam *team = self.teams[ indexPath.row ];
    cell.teamLabel.text = team.name;
    cell.teamDetailLabel.text = [NSString stringWithFormat:@"%@ - %@", team.activity.name, team.teamMemberType];
    
    if ( team.hasThumbnailPhoto )
    {
        cell.thumbnailImageView.image = team.loadedThumbnailPhoto;
    }
    else
    {
        cell.imageView.image = nil;
    }
    
    return cell;
}

#pragma mark - Private

//
// Loads the thumbnail photos for each of the teams that have one and
// refreshes the table view once complete
//
- (void)loadThumbnailPhotos
{
    for ( int i = 0; i < [self.teams count]; ++i )
    {
        [self dispatchConcurrentQueueFromUx:^{
            
            ITCTeam *team = self.teams[ i ];
            if ( team.hasThumbnailPhoto )
            {
                NSError *thumbnailPhotoError = nil;
                [team loadThumbnailPhotoWithError:&thumbnailPhotoError];
                ITCLogAndReturnOnError(thumbnailPhotoError, @"Failed to load thumbnail photo for team with id: %@", team.teamId);
                
                [self dispatchMainQueue:^{
                    [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:i inSection:0] ]
                                          withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
            
        }];
    }
}

@end
