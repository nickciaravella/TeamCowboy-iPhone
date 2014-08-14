//
//  ITCLoginViewController.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCLoginViewController.h"

#pragma mark - ITCLoginViewController (implementation)

@implementation ITCLoginViewController

#pragma mark - UITextFieldDelegate

//
// Every time the text in the username or password text fields
// change, re-evaluate if the sign in button should be enabled or disabled.
//
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    UITextField *otherTextField = ( textField == self.usernameTextField ) ? self.passwordTextField : self.usernameTextField;
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    self.signInButton.enabled = ( ![otherTextField.text isOnlyWhitespace] ) && ( ![newString isOnlyWhitespace] );
    
    // Always allow the user to edit the text.
    return YES;
}

#pragma mark - Actions

//
//
- (void)onCreateAccountButtonClicked:(UIButton *)sender
{
    ITCLog(@"User clicked the 'Create Account' button.");
    [self openUrlWithAbsoluteString:@"https://www.teamcowboy.com/register"];
}

//
//
- (void)onResetPasswordButtonClicked:(UIButton *)sender
{
    ITCLog(@"User clicked the 'Reset Password' button.");
    [self openUrlWithAbsoluteString:@"https://www.teamcowboy.com/resetPassword"];
}

//
//
- (void)onSignInButtonClicked:(UIButton *)sender
{
    ITCLog(@"User clicked the 'Sign in' button.");
    
    [self setViewsForLoading:YES];

    [self dispatchConcurrentQueueFromUx:^{
        
        NSError *signInError = [[ITCAppFactory authenticationProvider] authenticateUserWithUsername:self.usernameTextField.text
                                                                                           password:self.passwordTextField.text];
        [self dispatchMainQueue:^{
            [self setViewsForLoading:NO];
        }];
        
        if (signInError)
        {
            ITCLogError(signInError, @"There was an error signing in.");
            [[ITCAppFactory alertingService] showAlertForError:signInError
                                                     withTitle:@"Sign In Failed"
                                                       message:@"Make sure that you have entered your username and password correctly, then try again."
                                              acknowledgeBlock:^{}
                                                    retryBlock:nil];
        }
    }];
}

#pragma mark - Private helpers

//
//
- (void)setViewsForLoading:(BOOL)isLoading
{
    UIColor *textFieldFontColor = ( isLoading ) ? [UIColor lightGrayColor] : [UIColor blackColor];
    self.signInButton.enabled        = !isLoading;
    self.usernameTextField.enabled   = !isLoading;
    self.usernameTextField.textColor = textFieldFontColor;
    self.passwordTextField.enabled   = !isLoading;
    self.passwordTextField.textColor = textFieldFontColor;
    
    NSString *buttonTitle = ( isLoading ) ? @"Signing in..." : @"Sign in";
    [self.signInButton setTitle:buttonTitle forState:UIControlStateNormal];
}

@end
