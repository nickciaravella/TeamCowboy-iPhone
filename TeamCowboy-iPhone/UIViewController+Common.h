//
//  UIViewController+Common.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

@interface UIViewController (Common)

/**
 @brief Opens a URL from the given absolute string.
 @param urlString The absolute URL
 @return YES if the URL was successfully opened. NO otherwise.
 */
- (BOOL)openUrlWithAbsoluteString:(NSString *)urlString;

/**
 @brief Opens a URL for a location in Apple's maps.
 @param location The location.
 @return YES if the URL was successfully opened. NO otherwise.
 */
- (BOOL)openUrlForMapWithLocation:(NSString *)location;

@end
