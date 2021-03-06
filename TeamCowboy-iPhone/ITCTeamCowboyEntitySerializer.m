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
// Expected format:
//
// {
//    success : <bool>
//    body    : <dictionary>
// }
//
- (id)serializedObjectFromData:(NSData *)objectData
                         error:(NSError **)error
{
    if ( !error )
    {
        return nil;
    }
    if ( !objectData )
    {
        *error = [NSError errorWithCode:ITCErrorObjectSerialization message:@"No object data to be serialized."];
        return nil;
    }
    
    NSDictionary *objectDictionary = [NSJSONSerialization JSONObjectWithData:objectData
                                                                     options:NSJSONReadingAllowFragments
                                                                        error:error];
    if ( *error )
    {
        return nil;
    }
    if ( ![objectDictionary isKindOfClass:[NSDictionary class]] )
    {
        NSString *message = [NSString stringWithFormat:@"Outer object is not a dictionary. It is %@", [objectDictionary class]];
        *error = [NSError errorWithCode:ITCErrorObjectSerialization message:message];
        return nil;
    }
    
    id body = objectDictionary[ @"body" ];
    if ( self.isCollection )
    {
        if ( ![body isKindOfClass:[NSArray class]] )
        {
            NSString *message = [NSString stringWithFormat:@"Body element is not an array. It is %@", [body class]];
            *error = [NSError errorWithCode:ITCErrorObjectSerialization message:message];
            return nil;
        }
        
        NSMutableArray *entities = [NSMutableArray new];
        for ( id element in body )
        {
            id entity = [self entityFromDictionary:element withError:error];
            if ( *error )
            {
                return nil;
            }
            [entities addObject:entity];
        }
        
        return entities;
    }
    else
    {
        return [self entityFromDictionary:body withError:error];
    }
}

#pragma mark - Private

//
//
- (id)entityFromDictionary:(NSDictionary *)entityDictionary
                 withError:(NSError **)error
{
    if ( ![entityDictionary isKindOfClass:[NSDictionary class]] )
    {
        NSString *message = [NSString stringWithFormat:@"Body element is not a dictionary. It is %@", [entityDictionary class]];
        *error = [NSError errorWithCode:ITCErrorObjectSerialization message:message];
        return nil;
    }
    
    ITCSerializableObject *object = [[self.type alloc] initWithDictionary:entityDictionary];
    if ( !object )
    {
        NSString *message = [NSString stringWithFormat:@"Failed to serialize object type from dictionary. Type: %@, Dictionary: %@",
                             self.type, entityDictionary];
        *error = [NSError errorWithCode:ITCErrorObjectSerialization message:message];
        return nil;
    }
    
    return object;
}

@end
