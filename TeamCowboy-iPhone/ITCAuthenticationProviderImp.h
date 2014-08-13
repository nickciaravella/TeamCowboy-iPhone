//
//  ITCAuthenticationProviderImp.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAuthenticationProvider.h"

@interface ITCAuthenticationProviderImp : NSObject <ITCAuthenticationProvider>

// Making property writable
@property (nonatomic, strong, readwrite) ITCAuthenticationContext *authenticationContext;

@end
