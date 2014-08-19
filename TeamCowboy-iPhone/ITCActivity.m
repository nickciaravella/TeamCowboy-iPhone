//
//  ITCActivity.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCActivity.h"

@implementation ITCActivity

@synthesize activityId = _activityId;
@synthesize name       = _name;

#pragma mark - ITCSerializableObject

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (!(self = [super initWithDictionary:dictionary])) { return nil; }
    
    _activityId = dictionary[ @"activityId" ];
    _name       = dictionary[ @"name" ];
    
    return self;
}

- (NSDictionary *)dictionaryFormat
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary safeSetValue:self.activityId forKey:@"activityId"];
    [dictionary safeSetValue:self.name       forKey:@"name"];
    return dictionary;
}

@end
