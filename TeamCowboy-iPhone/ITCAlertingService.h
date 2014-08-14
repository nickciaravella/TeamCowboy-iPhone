//
//  ITCAlertingService.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

/**
 @brief Service for easily showing alerts.
 */
@interface ITCAlertingService : NSObject

/**
 @brief Shows an alert for an error.
 @param error            The error object. Default alerts are shown for some errors.
 @param title            Title for the alert if it is not a known error.
 @param message          Message for the alert if it is not a known error.
 @param acknowledgeBlock Block to be executed when the user accepts the alert.
 @param retryBlock       Block to be executed when the user wants to retry the operation.
 */
- (void)showAlertForError:(NSError *)error
                withTitle:(NSString *)title
                  message:(NSString *)message
         acknowledgeBlock:(void (^)())acknowledgeBlock
               retryBlock:(void (^)())retryBlock;

@end
