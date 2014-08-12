//
//  ITCAppFactory.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAuthenticationProvider.h"
#import "ITCTeamCowboyService.h"

/**
 @brief Factory for creating the application objects.
 */
@interface ITCAppFactory : NSObject

+ (id<ITCAuthenticationProvider>)authenticationProvider;
+ (id<ITCTeamCowboyService>)teamCowboyService;

@end
