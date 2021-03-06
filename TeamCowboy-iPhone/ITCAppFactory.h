//
//  ITCAppFactory.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAlertingService.h"
#import "ITCAuthenticationProvider.h"
#import "ITCCache.h"
#import "ITCFileService.h"
#import "ITCHttpConnection.h"
#import "ITCResourceService.h"
#import "ITCTeamCowboyService.h"

/**
 @brief Factory for creating the application objects.
 */
@interface ITCAppFactory : NSObject

+ (void)setShouldUseMocks:(BOOL)shouldUseMocks;
+ (BOOL)isVNextApp;

+ (ITCAlertingService *)alertingService;
+ (id<ITCAuthenticationProvider>)authenticationProvider;
+ (ITCCache *)cache;
+ (id<ITCFileService>)fileService;
+ (id<ITCHttpConnection>)httpConnection;
+ (ITCResourceService *)resourceService;
+ (id<ITCTeamCowboyService>)teamCowboyService;

@end
