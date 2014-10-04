//
//  ITCMoreTableViewController.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCMoreTableViewController.h"

#pragma mark - ITCMoreTableViewController ()

@interface ITCMoreTableViewController () <MFMailComposeViewControllerDelegate>

@end


#pragma mark - ITCMoreTableViewController (implementation)

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
        case 1:
            [self feedbackButtonClicked];
        default:
            break;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - MFMailComposeViewControllerDelegate

//
//
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

//
//
- (void)feedbackButtonClicked
{
    MFMailComposeViewController *mailController = [MFMailComposeViewController new];
    [mailController setToRecipients:@[ @"nick.ciaravella@live.com" ]];
    [mailController setSubject:@"Feedback on your iOS app"];
    [mailController setMailComposeDelegate:self];
    [self presentViewController:mailController animated:YES completion:nil];
}

@end
