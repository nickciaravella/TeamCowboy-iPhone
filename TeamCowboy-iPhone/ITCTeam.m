//
//  ITCTeam.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCTeam.h"

@implementation ITCTeam

#pragma ITCSerializableObject

//
//
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (!(self = [super initWithDictionary:dictionary])) { return nil; }
    
    _teamId = dictionary[ @"teamId" ];
    _name   = dictionary[ @"name" ];
    
    return self;
}

//
//
- (NSDictionary *)dictionaryFormat
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary safeSetValue:self.teamId forKey:@"teamId"];
    [dictionary safeSetValue:self.name forKey:@"name"];
    return dictionary;
}

#pragma mark - ITCTeam

@synthesize teamId = _teamId;
@synthesize name   = _name;

@end
