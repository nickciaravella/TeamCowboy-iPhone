//
//  UIViewController+Common.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Common)

/**
 @brief Opens a URL from the given absolute string.
 @param urlString The absolute URL
 @return YES if the URL was successfully opened. NO otherwise.
 */
- (BOOL)openUrlWithAbsoluteString:(NSString *)urlString;

@end
