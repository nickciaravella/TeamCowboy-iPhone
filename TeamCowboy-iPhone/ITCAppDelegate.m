//
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAppDelegate.h"
#import "ITCAppTabBarController.h"

@implementation ITCAppDelegate

//
//
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ITCAppTabBarController *tabBarController = [[ITCAppTabBarController alloc] init];
    tabBarController.viewControllers = @[
                                            [[ITCAppFactory resourceService] initialControllerFromStoryboard:@"Events"],
                                            [[ITCAppFactory resourceService] initialControllerFromStoryboard:@"Teams"],
                                            [[ITCAppFactory resourceService] initialControllerFromStoryboard:@"Messages"],
                                            [ITCMoreTableViewController navigationControllerWithMoreTableViewControllerWithDelegate:tabBarController]
                                        ];
    self.window.rootViewController = tabBarController;
        
    return YES;
}

@end
