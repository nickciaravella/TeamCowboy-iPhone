//
//  ITCAuthenticationRequestHandler.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITCHttpConnectionDelegate.h"

@interface ITCAuthenticationRequestHandler : NSObject <ITCTeamCowboyRequestHandler>

@property (nonatomic, assign) NSUInteger count_timesCalled;

@property (nonatomic, strong) NSURLRequest *param_urlRequest;
@property (nonatomic, strong) NSString     *param_username;
@property (nonatomic, strong) NSString     *param_password;

@property (nonatomic, strong) ITCAuthenticationContext *return_authContext;
// TODO: Team Cowboy error
@property (nonatomic, strong) NSHTTPURLResponse        *return_response;
@property (nonatomic, strong) NSError                  *return_httpError;

- (void)setAuthContextWithUserId:(NSString *)userId
                           token:(NSString *)token;

@end
