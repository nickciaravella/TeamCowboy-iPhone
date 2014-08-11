//
//  ITCLoginViewController.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 @details Controller for the login page.
 */
@interface ITCLoginViewController : UIViewController <UITextFieldDelegate>

// Outlets
@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIButton    *signInButton;

// Actions
- (IBAction)onSignInButtonClicked:(UIButton *)sender;
- (IBAction)onCreateAccountButtonClicked:(UIButton *)sender;
- (IBAction)onResetPasswordButtonClicked:(UIButton *)sender;

@end
