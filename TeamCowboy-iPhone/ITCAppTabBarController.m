//
//  ITCAppTabBarController.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAppTabBarController.h"

@implementation ITCAppTabBarController

#pragma mark - UIViewController

//
//
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ( ![ITCAppFactory authenticationProvider].authenticationContext )
    {
        [self presentLoginController];
    }
}

#pragma mark - ITCLoginViewControllerDelegate

//
//
- (void)loginControllerDidCompleteAuthentication:(ITCLoginViewController *)loginController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ITCMoreTableViewControllerDelegate

//
//
- (void)moreControllerDidClickSignOutButton:(ITCMoreTableViewController *)controller
{
    [[ITCAppFactory authenticationProvider] removeAuthentication];
    self.selectedIndex = 0;
    [self presentLoginController];
}

#pragma mark - Private

- (void)presentLoginController
{
    [self presentViewController:[ITCLoginViewController loginControllerWithDelegate:self]
                       animated:YES
                     completion:nil];
}

@end
