//
//  NSArray+Common.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Common)

/**
 @brief Transforms each element in the array using the given block, returning a new array.
 @param block A block to execute the tranformation. The parameter is the original element and the return value should be the transformed element. If this returns nil, the element will be omitted from the new array.
 @return The new transformed array.
 */
- (NSArray *)arrayByTransformingElementsUsingBlock:(id (^)(id element))block;

/**
 @brief Filters an array using a block.
 @param block The block that determines if an element should be present in the filtered array. The parameter is the element and the return value is YES if it should be present in the array, NO otherwise.
 @return The filtered array.
 */
- (NSArray *)filteredArrayUsingBlock:(BOOL (^)(id element))block;

@end

@interface NSMutableArray (Common)

/**
 @brief Adds an object to the array. If the object is nil, this is a no-op.
 @param object The object to be added to the array.
 */
- (void)safeAddObject:(id)object;

@end