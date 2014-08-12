//
//  NSString+Common.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

@implementation NSString (Common)

//
//
- (BOOL)isOnlyWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
}

@end
