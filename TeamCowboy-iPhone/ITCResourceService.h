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

/**
 @brief Gets the controller from the storyboard in the main bundle with the given identifier.
 @param storyboardName Name of the storyboard.
 @param storyboardId   The ID of the controller in the storyboard.
 @return The instantiated controller.
 */
- (id)controllerFromStoryboard:(NSString *)storyboardName
                withIdentifier:(NSString *)storyboardId;

/**
 @brief Gets an image from the main bundle.
 @param imageName The name of the image.
 @param extension The extension of the image.
 @return An image object. Nil on error.
 */
- (UIImage *)imageWithName:(NSString *)imageName
                 extension:(NSString *)extension;

@end
