//
//  ITCAuthenticationContext.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCAuthenticationContext.h"

@implementation ITCAuthenticationContext

#pragma mark - ITCAuthenticationContext

@synthesize token  = _token;
@synthesize userId = _userId;

#pragma mark - ITCSerializableObject overrides

//
//
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (!(self = [super initWithDictionary:dictionary])) { return nil; }
    
    _token  = dictionary[@"token"];
    _userId = [dictionary[@"userId"] unsignedIntegerValue];
    
    return self;
}

@end
