//
//  ITCTeamCowboyRequestSigner.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCTeamCowboyRequestSigner.h"

@implementation ITCTeamCowboyRequestSigner

//
//
+ (NSString *)requestSignatureWithPrivateKey:(NSString *)privateKey
                                  httpMethod:(NSString *)httpMethod
                            teamCowboyMethod:(NSString *)teamCowboyMethod
                                   timestamp:(NSUInteger)timestamp
                                       nonce:(NSString *)nonce
                           requestParameters:(NSDictionary *)requestParameters
{
    return nil;
}

@end
