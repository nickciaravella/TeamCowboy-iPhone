//
//  ITCTeamCowboyError.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCTeamCowboyError.h"

#pragma mark - ITCTeamCowboyError ()

@interface ITCTeamCowboyError ()

@property (nonatomic, strong) NSString *errorCode;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, strong) NSString *httpResponse;

@end

#pragma mark - ITCTeamCowboyError (implementation)

@implementation ITCTeamCowboyError

#pragma mark - ITCSerializableObject

//
//
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (!(self = [super initWithDictionary:dictionary])) { return nil; }
    
    NSDictionary *errorDictionary = dictionary[ @"error" ];
    if ( !errorDictionary || ![errorDictionary isKindOfClass:[NSDictionary class]] )
    {
        return  nil;
    }
    
    _errorCode    = errorDictionary[ @"errorCode" ];
    _errorMessage = errorDictionary[ @"message" ];
    _httpResponse = errorDictionary[ @"httpResponse" ];
        
    return self;
}

#pragma mark - ITCTeamCowboyError

//
//
- (NSError *)error
{
    NSString *message = [NSString stringWithFormat:@"HTTP Response: %@, Code: %@, Message: %@",
                         self.httpResponse, self.errorCode, self.errorMessage];

    return [NSError errorWithCode:ITCErrorGenericTeamCowboyError message:message];
}

@end
