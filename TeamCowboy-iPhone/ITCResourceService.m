//
//  ITCResourceService.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCResourceService.h"

@implementation ITCResourceService

//
//
- (id)initialControllerFromStoryboard:(NSString *)storyboardName
{
    return [[UIStoryboard storyboardWithName:storyboardName
                                      bundle:[NSBundle mainBundle]] instantiateInitialViewController];
}

//
//
- (id)controllerFromStoryboard:(NSString *)storyboardName
                withIdentifier:(NSString *)storyboardId
{
    return [[UIStoryboard storyboardWithName:storyboardName
                                      bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:storyboardId];
}

@end
