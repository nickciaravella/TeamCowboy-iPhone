//
//  ITCAuthenticationProviderImp.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAuthenticationProvider.h"

@interface ITCAuthenticationProviderImp : NSObject <ITCAuthenticationProvider>

// Make protocol properties writable.
@property (nonatomic, strong, readwrite) NSString *token;
@property (nonatomic, assign, readwrite) NSUInteger userId;

@end
