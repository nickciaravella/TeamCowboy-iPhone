//
//  ITCBasicButtonInfo.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCBasicButtonInfo.h"

@implementation ITCBasicButtonInfo

//
//
+ (ITCBasicButtonInfo *)buttonInfoWithTitle:(NSString *)title
                                     action:(void (^)())actionBlock
{
    ITCBasicButtonInfo *buttonInfo = [ITCBasicButtonInfo new];
    buttonInfo.title = title;
    buttonInfo.actionBlock = ( actionBlock ) ? actionBlock : ^{};
    return buttonInfo;
}

@end
