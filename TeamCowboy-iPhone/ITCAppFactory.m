//
//  ITCAppFactory.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAuthenticationProviderImp.h"
#import "ITCHttpConnectionImp.h"
#import "ITCTeamCowboyServiceImp.h"

const BOOL shouldUseMocks = NO;

@implementation ITCAppFactory

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
    return [ITCAuthenticationProviderImp new];
}

//
//
+ (id<ITCHttpConnection>)httpConnection
{
    return [ITCHttpConnectionImp new];
}

//
//
+ (id<ITCTeamCowboyService>)teamCowboyService
{
    return [ITCTeamCowboyServiceImp new];
}

@end
