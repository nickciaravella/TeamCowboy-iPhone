//
//  ITCAuthenticationProviderImp.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAuthenticationProviderImp.h"

@implementation ITCAuthenticationProviderImp

#pragma mark - ITCAuthenticationProviderImp

//
//
- (NSError *)authenticateUserWithUsername:(NSString *)username
                                 password:(NSString *)password
{
    [NSThread sleepForTimeInterval:3];
    return nil;
}

//
//
- (BOOL)isUserAuthenticated
{
    return self.userId && self.token;
}

@end
