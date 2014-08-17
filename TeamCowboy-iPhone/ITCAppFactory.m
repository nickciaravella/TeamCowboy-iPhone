//
//  ITCAppFactory.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAuthenticationProviderImp.h"
#import "ITCFileServiceImp.h"
#import "ITCHttpConnectionImp.h"
#import "ITCHttpConnectionMock.h"
#import "ITCTeamCowboyServiceImp.h"

static BOOL shouldUseMocks = NO;

@implementation ITCAppFactory

#pragma mark - Configuration

//
//
+ (void)setShouldUseMocks:(BOOL)useMocks
{
    shouldUseMocks = useMocks;
}

#pragma mark - Objects

//
//
+ (ITCAlertingService *)alertingService
{
    return [ITCAlertingService new];
}

//
//
+ (id<ITCAuthenticationProvider>)authenticationProvider
{
    static ITCAuthenticationProviderImp *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [ITCAuthenticationProviderImp new];
    });
    return singleton;
}

//
//
+ (ITCCache *)cache
{
    return [ITCCache new];
}

//
//
+ (id<ITCFileService>)fileService
{
    return [ITCFileServiceImp new];
}

//
//
+ (id<ITCHttpConnection>)httpConnection
{
    if ( shouldUseMocks )
    {
        static ITCHttpConnectionMock *singleton = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            singleton = [ITCHttpConnectionMock new];
        });
        return singleton;
    }
    
    return [ITCHttpConnectionImp new];
}

//
//
+ (ITCResourceService *)resourceService
{
    return [ITCResourceService new];
}

//
//
+ (id<ITCTeamCowboyService>)teamCowboyService
{
    return [ITCTeamCowboyServiceImp new];
}

@end
