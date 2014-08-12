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
    [self openUrlWithAbsoluteString:@"https://www.teamcowboy.com/register"];
}

//
//
- (void)onResetPasswordButtonClicked:(UIButton *)sender
{
    [self openUrlWithAbsoluteString:@"https://www.teamcowboy.com/resetPassword"];
}

//
//
- (void)onSignInButtonClicked:(UIButton *)sender
{
    [self setViewsForLoading:YES];

    [self dispatchConcurrentQueueFromUx:^{
        
        [[ITCAppFactory authenticationProvider] authenticateUserWithUsername:self.usernameTextField.text
                                                                    password:self.passwordTextField.text];
        [self dispatchMainQueue:^{ [self setViewsForLoading:NO]; }];
        
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
}

@end
