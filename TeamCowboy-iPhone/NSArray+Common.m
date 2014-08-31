//
//  NSArray+Common.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "NSArray+Common.h"

#pragma mark - NSArray (Common)

@implementation NSArray (Common)

//
//
- (NSArray *)arrayByTransformingElementsUsingBlock:(id (^)(id element))block
{
    NSMutableArray *transformedArray = [NSMutableArray new];
    for (id element in self)
    {
        id transformedElement = block(element);
        [transformedArray safeAddObject:transformedElement];
    }
    return transformedArray;
}

@end

#pragma mark - NSMutableArray (Common)

@implementation NSMutableArray (Common)

//
//
- (void)safeAddObject:(id)object
{
    if ( object )
    {
        [self addObject:object];
    }
}

@end