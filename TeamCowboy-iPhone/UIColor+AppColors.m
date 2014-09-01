//
//  UIColor+AppColors.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "UIColor+AppColors.h"

@implementation UIColor (AppColors)

//
//
+ (UIColor *)attendingColor
{
    return [UIColor colorWithRed:(67/255.0) green:(212/255.0) blue:(80/255.0) alpha:1.0];
}

//
//
+ (UIColor *)maybeAttendingColor
{
    return [UIColor colorWithRed:(212/255.0) green:(202/255.0) blue:(48/255.0) alpha:1.0];
}

//
//
+ (UIColor *)notAttendingColor
{
    return [UIColor colorWithRed:(209/255.0) green:(69/255.0) blue:(88/255.0) alpha:1.0];
}

@end
