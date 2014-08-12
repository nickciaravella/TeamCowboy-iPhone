//
//  NSObject+Concurrency.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

@implementation NSObject (Concurrency)

//
//
- (void)dispatchMainQueueIfNeeded:(void (^)())block
{
    if ( [NSThread isMainThread] )
    {
        block();
        return;
    }
    
    [self dispatchMainQueue:block];
}

//
//
- (void)dispatchMainQueue:(void (^)())block
{
    dispatch_async(dispatch_get_main_queue(), block);
}

//
//
- (void)dispatchConcurrentQueueFromUx:(void (^)())block
{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), block);
}

//
//
- (void)dispatchConcurrentQueueFromBackground:(void (^)())block
{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), block);
}

@end
