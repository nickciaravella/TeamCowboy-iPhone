//
//  ITCAppFactory.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAlertingService.h"
#import "ITCAuthenticationProvider.h"
#import "ITCHttpConnection.h"
#import "ITCTeamCowboyService.h"

/**
 @brief Factory for creating the application objects.
 */
@interface ITCAppFactory : NSObject

+ (void)setShouldUseMocks:(BOOL)shouldUseMocks;

+ (ITCAlertingService *)alertingService;
+ (id<ITCAuthenticationProvider>)authenticationProvider;
+ (id<ITCHttpConnection>)httpConnection;
+ (id<ITCTeamCowboyService>)teamCowboyService;

@end
