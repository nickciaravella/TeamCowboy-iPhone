//
//  ITCLoginViewController.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

@class ITCLoginViewController;

@protocol ITCLoginViewControllerDelegate <NSObject>

/**
 @brief Notifies the delgate that authentication has completed.
 @property loginController The controller that initiated the authentication.
 */
- (void)loginControllerDidCompleteAuthentication:(ITCLoginViewController *)loginController;

@end

@interface ITCLoginViewController : UIViewController <UITextFieldDelegate>

// Creation
+ (ITCLoginViewController *)loginControllerWithDelegate:(id<ITCLoginViewControllerDelegate>)delegate;

// Outlets
@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIButton    *signInButton;

// Actions
- (IBAction)onSignInButtonClicked:(UIButton *)sender;
- (IBAction)onCreateAccountButtonClicked:(UIButton *)sender;
- (IBAction)onResetPasswordButtonClicked:(UIButton *)sender;

// Delegate
@property (nonatomic, weak) id<ITCLoginViewControllerDelegate> delegate;

@end
