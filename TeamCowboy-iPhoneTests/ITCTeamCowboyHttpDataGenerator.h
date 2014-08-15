//
//  ITCTeamCowboyHttpDataGenerator.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITCTeamCowboyHttpDataGenerator : NSObject

+ (NSData *)dataForSuccessResponseWithEntity:(NSDictionary *)entity;

@end
