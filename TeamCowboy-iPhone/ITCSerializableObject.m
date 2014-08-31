//
//  ITCSerializableObject.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCSerializableObject.h"

@implementation ITCSerializableObject

#pragma mark - ITCSerializableObject

//
//
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (!(self = [super init])) { return nil; }
    
    NSDictionary *mapping = [[self class] propertyToKeyPathMapping];
    NSDictionary *embeddedObjectMapping = [[self class] embeddedObjectPropertyToClassMapping];
    NSArray *embeddedObjects = [embeddedObjectMapping allKeys];
    
    for (NSString *property in [mapping allKeys])
    {
        id value = [dictionary valueForKeyPath:mapping[property]];
        if ( !value ) continue;        
        
        if ( [value isKindOfClass:[NSArray class]] && [embeddedObjects containsObject:property] )
        {
            Class type = NSClassFromString(embeddedObjectMapping[property]);
            value = [value arrayByTransformingElementsUsingBlock:^id(NSDictionary *element) {
                return [[type alloc] initWithDictionary:element];
            }];
        }
        else if ([embeddedObjects containsObject:property])
        {
            Class type = NSClassFromString(embeddedObjectMapping[property]);
            value = [[type alloc] initWithDictionary:value];
        }

        [self setValue:value forKey:property];
    }
    
    return self;
}

//
//
- (NSDictionary *)dictionaryFormat
{
    NSMutableDictionary *dictionaryFormat = [NSMutableDictionary new];
    
    NSDictionary *mapping = [[self class] propertyToKeyPathMapping];
    NSDictionary *embeddedObjectMapping = [[self class] embeddedObjectPropertyToClassMapping];
    NSArray *embeddedObjects = [embeddedObjectMapping allKeys];
    
    for (NSString *property in [mapping allKeys])
    {
        id value = [self valueForKey:property];
        if ( !value ) continue;
        
        if ( [value isKindOfClass:[NSArray class]] && [embeddedObjects containsObject:property] )
        {
            value = [value arrayByTransformingElementsUsingBlock:^id(ITCSerializableObject *element) {
                return [element dictionaryFormat];
            }];
        }
        else if ([embeddedObjects containsObject:property])
        {
            value = [value dictionaryFormat];
        }
        
        [self addObject:value toDictionary:dictionaryFormat forKeyPath:mapping[property]];
    }
    
    return dictionaryFormat;
}

//
//
- (void)addObject:(id)object toDictionary:(NSMutableDictionary *)dictionary forKeyPath:(NSString *)keyPath
{
    NSArray *keys = [keyPath componentsSeparatedByString:@"."];
    
    NSMutableDictionary *lastDictionary = dictionary;
    for (int i = 0; i < [keys count] - 1; ++i)
    {
        if (lastDictionary[keys[i]] == nil)
        {
            lastDictionary[keys[i]] = [NSMutableDictionary new];
            lastDictionary = lastDictionary[keys[i]];
        }
        else
        {
            lastDictionary = lastDictionary[keys[i]];
        }
    }
    
    [lastDictionary setObject:object forKey:[keys lastObject]];
}

#pragma mark - NSObject

//
//
- (NSString *)description
{
    return [[self dictionaryFormat] description];
}

#pragma mark - Override in subclass

//
//
+ (NSDictionary *)propertyToKeyPathMapping
{
    return nil;
}

//
//
+ (NSDictionary *)embeddedObjectPropertyToClassMapping
{
    return nil;
}

@end
