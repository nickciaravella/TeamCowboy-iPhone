//
//  NSObject+Concurrency.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

@interface NSObject (Concurrency)

/**
 @brief Dispatches a block onto the global concurrent queue. This has a priority appropriate for scenarios affecting UX.
 @param block The block to be dispatched.
 */
- (void)dispatchConcurrentQueueFromUx:(void (^)())block;

/**
 @brief Dispatches a block onto the global concurrent queue. This has a priority appropriate for scenarios run from the background.
 @param block The block to be dispatched.
 */
- (void)dispatchConcurrentQueueFromBackground:(void (^)())block;

/**
 @brief Dispatches a block onto the main queue.
 @param block The block to be dispatched.
 */
- (void)dispatchMainQueue:(void (^)())block;

/**
 @brief Dispatches a block onto the main queue if it is not already there.
 @param block The block to be dispatched.
 */
- (void)dispatchMainQueueIfNeeded:(void (^)())block;

@end
