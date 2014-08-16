//
//  ITCResourceService.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

@interface ITCResourceService : NSObject

/**
 @brief Gets the initial controller from the storyboard in the main bundle.
 @param storyboardName Name of the storyboard.
 @return The instantiated controller.
 */
- (id)initialControllerFromStoryboard:(NSString *)storyboardName;

@end
