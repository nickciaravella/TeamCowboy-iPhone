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

    if ( [ITCAppFactory authenticationProvider].authenticationContext )
    {
        BOOL didLoadUserData = [self processLoginComplete];
        if ( didLoadUserData ) return;
    }
    
    [self presentLoginController];
}

#pragma mark - ITCLoginViewControllerDelegate

//
//
- (void)loginControllerDidCompleteAuthentication:(ITCLoginViewController *)loginController
{
    BOOL didLoadUserData = [self processLoginComplete];
    
    if ( didLoadUserData )
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
- (BOOL)processLoginComplete
{
    NSError *error = nil;
    ITCUser *loggedInUser = [ITCUser loadCurrentUserBypassingCache:NO withError:&error];
    
    if ( error )
    {
        [[ITCAppFactory alertingService] showAlertForError:error
                                                 withTitle:@"Something Went Wrong"
                                                   message:@"There was a problem loading your information from Team Cowboy."
                                          acknowledgeBlock:^{}
                                                retryBlock:^{ [self processLoginComplete]; }];
        return NO;
    }
    
    for (UINavigationController *navController in self.viewControllers)
    {
        UIViewController<ITCAppTabBarItem> *item = navController.viewControllers[0];
        if ( [item conformsToProtocol:@protocol(ITCAppTabBarItem)] )
        {
            [item startLoadingDataForUser:loggedInUser];
        }
    }
    
    return YES;
}

@end
