//
//  ITCAlertingService.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAlertingService.h"

#pragma mark - Statics

// Array of shown alerting services. This is needed to hold
// a reference to the service so that the delegate method
// will be called. If the service is not held, the object will
// be released since the UIAlertView only holds a weak reference
// to its delegate.
static NSMutableArray *alertingServices;

#pragma mark - ITCAlertingService ()

@interface ITCAlertingService () <UIAlertViewDelegate>

@property (nonatomic, strong) ITCBasicButtonInfo *cancelButtonInfo;
@property (nonatomic, strong) NSArray *buttonsInfo;

@end

#pragma mark - ITCAlertingService (implementation)

@implementation ITCAlertingService

#pragma mark - ITCAlertingService

//
//
- (void)showAlertForError:(NSError *)error
                withTitle:(NSString *)title
                  message:(NSString *)message
         acknowledgeBlock:(void (^)())acknowledgeBlock
               retryBlock:(void (^)())retryBlock
{
    [[self class] holdAlertingService:self];
    
    // Show standard text for connection issues.
    if ( [error.domain isEqualToString:NSURLErrorDomain] )
    {
        switch (error.code)
        {
            case NSURLErrorNotConnectedToInternet:
            {
                title   = @"Internet Not Connected";
                message = @"Your device is currently not connected to the internet. Connect your device to the internet and then try again.";
                break;
            }
            default:
            {
                title = @"Connection Issue";
                message = @"There was an issue trying to connect to Team Cowboy. This may be due to a weak internet connection.";
                break;
            }
        }
    }
    
    ITCBasicButtonInfo *cancelButton = [ITCBasicButtonInfo buttonInfoWithTitle:@"Ok"
                                                                        action:acknowledgeBlock];
    NSMutableArray *otherButtons = [NSMutableArray new];
    if (retryBlock)
    {
        [otherButtons addObject:[ITCBasicButtonInfo buttonInfoWithTitle:@"Try again"
                                                                 action:retryBlock]];
    }
    
    [self showAlertWithTitle:title
                     message:message
                cancelButton:cancelButton
                otherButtons:otherButtons];
}

//
//
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
              cancelButton:(ITCBasicButtonInfo *)cancelButton
              otherButtons:(NSArray *)otherButtons
{
    [[self class] holdAlertingService:self];
    self.cancelButtonInfo = cancelButton;
    self.buttonsInfo = otherButtons;
    
    [self dispatchMainQueueIfNeeded:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:self.cancelButtonInfo.title
                                              otherButtonTitles:nil];
        
        for (ITCBasicButtonInfo *buttonInfo in self.buttonsInfo)
        {
            NSInteger buttonIndex = [alert addButtonWithTitle:buttonInfo.title];
            buttonInfo.tag = buttonIndex;
        }
        
        ITCLog(@"Showing alert view: %@", alert);
        [alert show];
    }];
    
}


#pragma mark - UIAlertViewDelegate

//
//
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ITCLog(@"Alert view button was clicked at index: %li alerView: %@", buttonIndex, alertView);
    
    if ( buttonIndex == alertView.cancelButtonIndex )
    {
        self.cancelButtonInfo.actionBlock();
    }
    else
    {
        ITCBasicButtonInfo *buttonInfo = [self.buttonsInfo firstObjectUsingBlock:^BOOL(ITCBasicButtonInfo *element) {
            return ( element.tag == buttonIndex );
        }];
        buttonInfo.actionBlock();
    }
    
    [[self class] removeHeldAlertingService:alertView.delegate];
}

#pragma mark - Private class methods

//
//
+ (void)holdAlertingService:(ITCAlertingService *)service
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertingServices = [NSMutableArray new];
    });
    
    [alertingServices addObject:service];
}

//
//
+ (void)removeHeldAlertingService:(ITCAlertingService *)service
{
    ITCAssert([alertingServices containsObject:service],
              @"Service should be held. Service: %@, Held services: %@", service, alertingServices);
    [alertingServices removeObject:service];
}

@end
