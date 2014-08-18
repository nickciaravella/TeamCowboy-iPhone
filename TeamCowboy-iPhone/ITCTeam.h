//
//  ITCTeam.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCSerializableObject.h"

@interface ITCTeam : ITCSerializableObject

@property (nonatomic, readonly) NSString *teamId;
@property (nonatomic, readonly) NSString *name;

@end
