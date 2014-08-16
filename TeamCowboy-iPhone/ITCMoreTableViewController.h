//
//  ITCMoreTableViewController.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

@class ITCMoreTableViewController;

@protocol ITCMoreTableViewControllerDelegate <NSObject>

/**
 @brief Alerts the delegate that the user clicked the sign out button.
 @param controller The More Table View Controller
 */
- (void)moreControllerDidClickSignOutButton:(ITCMoreTableViewController *)controller;

@end

@interface ITCMoreTableViewController : UITableViewController

// Creation
+ (UINavigationController *)navigationControllerWithMoreTableViewControllerWithDelegate:(id<ITCMoreTableViewControllerDelegate>)delegate;

// Delegate
@property (nonatomic, weak) id<ITCMoreTableViewControllerDelegate> delegate;

@end
