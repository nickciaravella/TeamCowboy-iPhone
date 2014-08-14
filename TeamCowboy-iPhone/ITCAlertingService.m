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

@property (nonatomic, strong) void (^acknowledgeBlock)();
@property (nonatomic, strong) void (^retryBlock)();

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
    
    self.acknowledgeBlock = acknowledgeBlock;
    self.retryBlock = retryBlock;
    
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
    
    [self dispatchMainQueueIfNeeded:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        if (retryBlock)
        {
            [alert addButtonWithTitle:@"Try again"];
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
    
    [[self class] removeHeldAlertingService:alertView.delegate];
    
    if ( buttonIndex == alertView.cancelButtonIndex )
    {
        if ( self.acknowledgeBlock ) self.acknowledgeBlock();
    }
    else
    {
         if (self.retryBlock) self.retryBlock();
    }
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
