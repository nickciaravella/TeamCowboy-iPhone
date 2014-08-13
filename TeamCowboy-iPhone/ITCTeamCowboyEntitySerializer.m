//
//  ITCTeamCowboyEntitySerializer.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCTeamCowboyEntitySerializer.h"

#pragma mark -  ITCTeamCowboyEntitySerializer ()

@interface ITCTeamCowboyEntitySerializer ()

@property (nonatomic, strong) Class type;
@property (nonatomic, assign) BOOL isCollection;

@end

#pragma mark - ITCTeamCowboyEntitySerializer (implementation)

@implementation ITCTeamCowboyEntitySerializer

#pragma mark - ITCTeamCowboyEntitySerializer

//
//
+ (ITCTeamCowboyEntitySerializer *)serializerForClass:(Class)type
                                         isCollection:(BOOL)isACollection
{
    ITCTeamCowboyEntitySerializer *serializer = [ITCTeamCowboyEntitySerializer new];
    serializer.type = type;
    serializer.isCollection = isACollection;
    return serializer;
}


#pragma mark - ITCObjectSerializer

//
//
- (id)serializedObjectFromData:(NSData *)objectData
{
    return nil;
}

@end
