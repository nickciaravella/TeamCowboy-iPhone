//
//  ITCTeamCowboyRequestSigner.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITCTeamCowboyRequestSigner : NSObject

/**
 @brief Generates a request signature for use with the Team Cowboy API.
 @param privateKey        The private key for use with the Team Cowboy API
 @param httpMethod        The HTTP method for the request
 @param teamCowboyMethod  The Team Cowboy method being called
 @param timestamp         The timestamp of the request
 @param nonce             A unique nonce used for the request
 @param requestParameters The parameters being sent in the request body
 @return The generated signature.
 */
+ (NSString *)requestSignatureWithPrivateKey:(NSString *)privateKey
                                  httpMethod:(NSString *)httpMethod
                            teamCowboyMethod:(NSString *)teamCowboyMethod
                                   timestamp:(NSUInteger)timestamp
                                       nonce:(NSString *)nonce
                           requestParameters:(NSDictionary *)requestParameters;

@end
