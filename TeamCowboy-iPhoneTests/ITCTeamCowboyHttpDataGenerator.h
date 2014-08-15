//
//  ITCTeamCowboyHttpDataGenerator.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITCTeamCowboyHttpDataGenerator : NSObject

+ (NSData *)dataForSuccessResponseWithEntity:(NSDictionary *)entity;
+ (NSData *)dataForErrorResponseWithCode:(NSString *)code
                                 message:(NSString *)message
                              httpStatus:(NSString *)httpStatus;

+ (NSURL *)teamCowboySecureUrl;

@end
