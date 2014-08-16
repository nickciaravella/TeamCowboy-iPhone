//
//  ITCAppTabBarController.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAppTabBarController.h"

@implementation ITCAppTabBarController

#pragma mark - UIViewController

//
//
- (void)viewDidLoad
{
    [super viewDidLoad];
}

//
//
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ( ![ITCAppFactory authenticationProvider].authenticationContext )
    {
        [self presentViewController:[ITCLoginViewController loginControllerWithDelegate:self]
                           animated:YES
                         completion:nil];
    }
}

#pragma mark - ITCLoginViewControllerDelegate

//
//
- (void)loginControllerDidCompleteAuthentication:(ITCLoginViewController *)loginController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
