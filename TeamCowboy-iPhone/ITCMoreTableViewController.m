//
//  ITCMoreTableViewController.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCMoreTableViewController.h"

@implementation ITCMoreTableViewController

#pragma mark - ITCMoreTableViewController

//
//
+ (UINavigationController *)navigationControllerWithMoreTableViewControllerWithDelegate:(id<ITCMoreTableViewControllerDelegate>)delegate
{
    UINavigationController *navController = [[ITCAppFactory resourceService] initialControllerFromStoryboard:@"More"];
    ITCMoreTableViewController *moreController = navController.viewControllers[0];
    moreController.delegate = delegate;
    return navController;
}

#pragma mark - UITableViewDelegate

//
//
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            [self.delegate moreControllerDidClickSignOutButton:self];
            break;
            
        default:
            break;
    }
}

@end
