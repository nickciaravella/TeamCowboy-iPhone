//
//  ITCAppTabBarController.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAppTabBarController.h"
#import "ITCAppTabBarItem.h"

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
    
    [self processLoginComplete];
}

#pragma mark - ITCLoginViewControllerDelegate

//
//
- (void)loginControllerDidCompleteAuthentication:(ITCLoginViewController *)loginController
{
    [self processLoginComplete];
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

//
//
- (void)presentLoginController
{
    [self presentViewController:[ITCLoginViewController loginControllerWithDelegate:self]
                       animated:YES
                     completion:nil];
}

//
//
- (void)processLoginComplete
{
    NSError *error = nil;
    ITCUser *loggedInUser = [ITCUser loadCurrentUserBypassingCache:NO withError:&error];
    
    for (UINavigationController *navController in self.viewControllers)
    {
        UIViewController<ITCAppTabBarItem> *item = navController.viewControllers[0];
        if ( [item conformsToProtocol:@protocol(ITCAppTabBarItem)] )
        {
            [item startLoadingDataForUser:loggedInUser];
        }
    }
    
    // TODO: Show error if we can't load the user.
}

@end
