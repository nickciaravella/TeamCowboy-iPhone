//
//  ITCAppTabBarItem.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCUser.h"

@protocol ITCAppTabBarItem <NSObject>

- (void)startLoadingDataForUser:(ITCUser *)user;

@end
