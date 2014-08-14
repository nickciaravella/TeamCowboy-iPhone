//
//  ITCAppFactory.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAuthenticationProviderImp.h"

const BOOL shouldUseMocks = YES;

@implementation ITCAppFactory

+ (id<ITCAuthenticationProvider>)authenticationProvider
{
    return [ITCAuthenticationProviderImp new];
}

+ (id<ITCTeamCowboyService>)teamCowboyService
{
    return nil;
}

@end